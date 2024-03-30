import argparse
import os
import sys
import subprocess
import time
import uuid
from pathlib import Path



# Define variables
parser = argparse.ArgumentParser()
parser.add_argument('-n', '--name', help='Name of the Virtualbox server', required=True)
parser.add_argument('-m', '--memory', help='Memory size of the Virtualbox server', required=True)
parser.add_argument('-c', '--cpu', help='Number of CPUs of the Virtualbox server', required=True)
parser.add_argument('-d', '--disk', help='Disk size of the Virtualbox server', required=True)
parser.add_argument('-o', '--os', help='Operating system of the Virtualbox server', required=True)
parser.add_argument('-u', '--user', help='User of the Virtualbox server', required=True)
parser.add_argument('-f', '--folder', help='Folder of the Virtualbox server', required=True)

# Parse arguments
args = parser.parse_args()

# Create the folder structure based on args.name
server_folder = os.path.join('tools', 'vbox', 'servers', args.name)
configs_folder = os.path.join(server_folder, 'configs')
images_folder = os.path.join(server_folder, 'images')

# Ensure the server folder and subfolders exist
os.makedirs(server_folder, exist_ok=True)
os.makedirs(configs_folder, exist_ok=True)
os.makedirs(images_folder, exist_ok=True)

# Construct paths for cloud-init configuration files
user_data_path = os.path.join(configs_folder, f'user-data')
meta_data_path = os.path.join(configs_folder, f'meta-data')
network_config_path = os.path.join(configs_folder, f'network-config')

vm_id = str(uuid.uuid4())
# Construct paths for image files
img_path = os.path.join(images_folder, 'ubuntu-22.04-server-cloudimg-official-amd64.img')
raw_path = os.path.join(images_folder, 'ubuntu-22.04-server-cloudimg-amd64.raw')
vdi_path = os.path.join(images_folder, 'ubuntu-22.04-server-cloudimg-amd64.vdi')
hd_name = os.path.join(images_folder, f'{args.name}-{vm_id}.vdi')




# Define functions

# Create seed.iso
def create_seed_iso():
    # Read user-data from file
    with open(user_data_path, 'r') as user_data_file:
        user_data = user_data_file.read()

    # Read meta-data from file
    with open(meta_data_path, 'r') as meta_data_file:
        meta_data = meta_data_file.read()

    # Read network-config from file
    with open(network_config_path, 'r') as network_config_file:
        network_config = network_config_file.read()

    # Write user-data to the correct path
    with open(os.path.join(configs_folder, 'user-data'), 'w') as f:
        f.write(user_data)
    # Write meta-data to the correct path
    with open(os.path.join(configs_folder, 'meta-data'), 'w') as f:
        f.write(meta_data)

    # Write network-config to the correct path
    with open(os.path.join(configs_folder, 'network-config'), 'w') as f:
        f.write(network_config)

    # Create seed.iso with network-config user-data and meta-data in the correct folder
    subprocess.run(['cloud-localds', '--network-config', os.path.join(configs_folder, 'network-config'), os.path.join(images_folder, 'cloud-init.iso'), os.path.join(configs_folder, 'user-data'), os.path.join(configs_folder, 'meta-data')])


def download_ubuntu_img():
    # Check if raw image file already exists
    if not os.path.exists(raw_path):
        # Download Ubuntu img
        subprocess.run(['wget', 'https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img', '-O', img_path])

        # Convert from img to raw image using qemu-img
        subprocess.run(['qemu-img', 'convert', '-O', 'raw', img_path, raw_path])
        # Convert from raw image to vdi image using VBoxManage
        subprocess.run(['VBoxManage', 'convertfromraw', raw_path, hd_name, '--format', 'VDI'])


def create_vbox_server(name, memory, cpu, disk, os, user, user_data_path, meta_data_path):
    # Check if VM already exists and ask if you want to delete or create a new name
    # Define paths
    # vdi_full_path = '~/VirtualBox\ VMs/ubuntu/ubuntu.vdi'
    # cloud_init_iso_full_path = '~/VirtualBox\ VMs/ubuntu/cloud-init.iso'
    subprocess.run(['VBoxManage', 'modifyhd', 'disk', hd_name, '--resize', disk])
    # Create Virtualbox server
    subprocess.run(['VBoxManage', 'createvm', '--name', name, '--ostype', os, '--register'])

    # Modify Virtualbox server
    subprocess.run(['VBoxManage', 'modifyvm', name, '--memory', memory, '--cpus', cpu, '--nic1', "bridged", '--bridgeadapter1', "eno1", '--nic2', "bridged", '--bridgeadapter2', "eno1"])

    # Modify Virtualbox to turn on nested hardware virtualization
    subprocess.run(['VBoxManage', 'modifyvm', name, '--nested-hw-virt', 'on'])

    # Modufy Virtualbox server turn on UTC
    subprocess.run(['VBoxManage', 'modifyvm', name, '--rtcuseutc', 'on'])
    # Set boot order
    subprocess.run(['VBoxManage', 'modifyvm', name, '--boot1', 'disk', '--boot2', 'dvd', '--boot3', 'none', '--boot4', 'none'])

    # Create Virtualbox server disk
    subprocess.run(['VBoxManage', 'createmedium', 'disk', '--filename', hd_name, '--size', disk])

    # Attach Virtualbox server disk
    subprocess.run(['VBoxManage', 'storagectl', name, '--name', 'SATA Controller', '--add', 'sata', '--controller', 'IntelAHCI'])

    # Attach Virtualbox server disk
    subprocess.run(['VBoxManage', 'storageattach', name, '--storagectl', 'SATA Controller', '--port', '0', '--device', '0', '--type', 'hdd', '--medium', hd_name])

    # Attach Virtualbox server ISO
    subprocess.run(['VBoxManage', 'storageattach', name, '--storagectl', 'SATA Controller', '--port', '1', '--device', '0', '--type', 'dvddrive', '--medium', f'{images_folder}/cloud-init.iso'])
    # Increase the VRAM to 16MB
    subprocess.run(['VBoxManage', 'modifyvm', name, '--vram', '128'])

    # Start Virtualbox server
    subprocess.run(['VBoxManage', 'startvm', name, '--type', 'gui'])

    # Wait for Virtualbox server to start
    time.sleep(10)

    # Get Virtualbox server IP
    ip = subprocess.run(['VBoxManage', 'guestproperty', 'get', name, '/VirtualBox/GuestInfo/Net/0/V4/IP'], stdout=subprocess.PIPE).stdout.decode('utf-8').split(' ')[1].rstrip()
    print(f'IP: {ip}')

def main():
    # Create seed.iso
    create_seed_iso()
    # Download Ubuntu img and convert to raw image
    download_ubuntu_img()
    # Create Virtualbox server
    create_vbox_server(args.name, args.memory, args.cpu, args.disk, args.os, args.user, user_data_path, meta_data_path)

# Main function
if __name__ == '__main__':
    main()

# Exit
sys.exit(0)
