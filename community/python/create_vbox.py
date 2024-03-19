# Create Virtualbox server with Python and ArgParse

# Import modules
import argparse
import os
import sys
import subprocess
import time
import uuid
from time import sleep

# Define variables
parser = argparse.ArgumentParser()
parser.add_argument('-n', '--name', help='Name of the Virtualbox server', required=True)
parser.add_argument('-m', '--memory', help='Memory size of the Virtualbox server', required=True)
parser.add_argument('-c', '--cpu', help='Number of CPUs of the Virtualbox server', required=True)
parser.add_argument('-d', '--disk', help='Disk size of the Virtualbox server', required=True)
parser.add_argument('-o', '--os', help='Operating system of the Virtualbox server', required=True)
parser.add_argument('-u', '--user', help='User of the Virtualbox server', required=True)

# Parse arguments
args = parser.parse_args()

img_path = '/home/administrator/localprojects/code/armyknife-tier1/ubuntu-22.04-server-cloudimg-official-amd64.img'
vdi_path = '/home/administrator/localprojects/code/armyknife-tier1/ubuntu-22.04-server-cloudimg-amd64.vdi'
raw_path = '/home/administrator/localprojects/code/armyknife-tier1/ubuntu-22.04-server-cloudimg-amd64.raw'
hd_name =  f'/home/administrator/localprojects/code/armyknife-tier1/{args.name}.vdi'
#iso_name =  f'/home/administrator/localprojects/code/armyknife-tier1/cloud-init.iso'
vm_id = str(uuid.uuid4())



# Define functions

def create_seed_iso():
    # create user-data
    user_data = '''#cloud-config
    hostname: ubuntu
    manage_etc_hosts: true
    users:
      - name: ubuntu
        sudo: ALL=(ALL) NOPASSWD:ALL
        groups: users, admin
        home: /home/ubuntu
        shell: /bin/bash
        lock_passwd: false
        plain_text_passwd: 'ubuntu'
        chpasswd: { expire: False }
        ssh_pwauth: True
        ssh_authorized_keys:
          - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDnrpx0iW124V5hQwqExGWnd2dyTL2XhbLyly6vmuyUMQPyq3PByJfvyjNvhNh/TQLD1B8PlV82j9nKBLY5C4lrvKT0eGf9o3q3DYYpQr8E13WwSvf72KMYX9yer440tWD9X4G4YA8IVvAqeH/Fxd82SDOjkN4r9QBqLocom2JWwuShbgAPcyjA87ozLkL8NintWjG2X62YvVebchN4JOZRuu/6wR6QKuDDpg/llQv8S+uk1vsMHDoeuatU4qnM23dhWB84L8Fwua58gwVCnrQtxRo9Zerer/cLBNDOOBaNPy9Mfj5mZ901drePQwX+Xh/4emZPS8fhyIuF6QSC4Na5xdgoHHUXQjlOfvif3oYHudLtpl8AGT2aFKVr6u75WuvmcpjQs+vhsCdDI1Vkx+RhqcoHRVny18e58XcOr0s6HBjM9JV/XtSRKL1d4yM84ivLarHFTKWg/jUPqrVJYwTDwR97larAt5POuCKqHziwOmX6cR3iC7mkC94Hin7PzmpBDs7b1DVKtR+cCpcm+KldSZ6WjpHp3TyB9bN3JKJr44UtpxZ+ncxy1IO544u0vDVcQGdf338e5XxiqY+KKJe8vNlMMwc5PYroMXYIhqgsJEj0BUQUYfP4arha+NHV413sR5mRyS0Q8xevb4Qg26KbddpzuGg0JAR4OdW37a/9BQ== administrator@badrobot
    packages:
        - qemu-guest-agent
        - dkms  # Required for VirtualBox Guest Additions
    write_files:
    - content: |
        #!/bin/bash
        mount -o loop /opt/VirtualBox/VBoxGuestAdditions_64.iso /media/VirtualBoxGuestAdditions
        sudo /media/VirtualBoxGuestAdditions/VBoxLinuxAdditions.run
        path: /usr/local/bin/install_guest_additions.sh
    - content: |
        [Unit]
        Description=Install VirtualBox Guest Additions
        After=network-online.target

        [Service]
        ExecStart=/usr/local/bin/install_guest_additions.sh

        [Install]
        WantedBy=multi-user.target
        path: /etc/systemd/system/install-guest-additions.service
    runcmd:
    - systemctl enable install-guest-additions.service
    - echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
    - sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    - systemctl restart sshd
    '''
    # create meta-data
    meta_data = f'instance-id: ubuntu-{vm_id}\nlocal-hostname: ubuntu'

    # Write user-data
    with open('user-data', 'w') as f:
        f.write(user_data)
    # Write meta-data
    with open('meta-data', 'w') as f:
        f.write(meta_data)
        
    # create network configuration for seed.iso 
    network_config = '''version: 2
    ethernets:
        enp0s3:
            dhcp4: true
        enp0s8:
            dhcp4: true
    '''
    # Write network-config
    with open('network-config', 'w') as f:
        f.write(network_config)
        
    # create seed.iso with network-config user-data and meta-data
    subprocess.run(['cloud-localds', '--network-config', 'network-config', 'cloud-init.iso', 'user-data', 'meta-data'])
    
def download_ubuntu_img():
    # Download Ubuntu img if does not exist    
    # if not os.path.exists(img_path):
    #     # Download Ubuntu img
    #     subprocess.run(['wget', 'https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img', '-O', img_path])
    
    # Convert from raw to vdi image with qemu-img qemu-img convert -O raw "${img}" "${img_raw}"
    subprocess.run(['wget', 'https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img', '-O', img_path])
    subprocess.run(['qemu-img', 'convert', '-O', 'raw', img_path, raw_path])
    subprocess.run(['VBoxManage', 'convertfromraw', raw_path, hd_name, '--format', 'VDI'])
    # if not os.path.exists(vdi_path):
    #     # Convert Ubuntu img to vdi image
    #     subprocess.run(['VBoxManage', 'convertfromraw', raw_path, vdi_path, '--format', 'VDI'])
    
    # sleep(10)

# Create Virtualbox server
def create_vbox_server(name, memory, cpu, disk, os, user):
    # check if previous name already exists and deregister it
    #subprocess.run(['VBoxManage', 'unregistervm', name, '--delete'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    
    subprocess.run(['VBoxManage', 'modifyhd', 'disk', hd_name, '--resize', disk])
    # Create Virtualbox server
    #vm_name = args.name + "_" + str(int(time.time()))  # Add a timestamp to the VM name
    subprocess.run(['VBoxManage', 'createvm', '--name', name, '--ostype', os, '--uuid', vm_id, '--register'])
    
    # Modify Virtualbox server
    subprocess.run(['VBoxManage', 'modifyvm', name, '--memory', memory, '--cpus', cpu, '--nic1', "bridged", '--bridgeadapter1', "wlp4s0", '--nic2', "bridged", '--bridgeadapter2', "wlp4s0"])
    
    # Modify Virtualbox to turn on nested hardware virtualization
    subprocess.run(['VBoxManage', 'modifyvm', name, '--nested-hw-virt', 'on'])
    
    # Set boot order
    subprocess.run(['VBoxManage', 'modifyvm', name, '--boot1', 'disk', '--boot2', 'dvd', '--boot3', 'none', '--boot4', 'none'])
    
    # Create Virtualbox server disk
    subprocess.run(['VBoxManage', 'createmedium', 'disk', '--filename', vdi_path, '--size', disk])
    
    # Attach Virtualbox server disk
    subprocess.run(['VBoxManage', 'storagectl', name, '--name', 'SATA Controller', '--add', 'sata', '--controller', 'IntelAHCI'])
    subprocess.run(['VBoxManage', 'storagectl', name, '--name', 'IDE', '--add', 'ide', '--controller', 'PIIX4'])
    
    # Attach Virtualbox server disk
    subprocess.run(['VBoxManage', 'storageattach', name, '--storagectl', 'SATA Controller', '--port', '0', '--device', '0', '--type', 'hdd', '--medium', hd_name])
    
    # Attach Virtualbox server ISO
    subprocess.run(['VBoxManage', 'storageattach', name, '--storagectl', 'SATA Controller', '--port', '1', '--device', '0', '--type', 'dvddrive', '--medium', 'cloud-init.iso'])
    # Rezise Virtualbox server disk
    
    # Start Virtualbox server
    subprocess.run(['VBoxManage', 'startvm', name, '--type', 'gui'])
    
    # Wait for Virtualbox server to start
    time.sleep(10)
    # Get Virtualbox server IP
    ip = subprocess.run(['VBoxManage', 'guestproperty', 'get', name, '/VirtualBox/GuestInfo/Net/0/V4/IP'], stdout=subprocess.PIPE).stdout.decode('utf-8').split(' ')[1].rstrip()
    print(f'IP: {ip}')    

# Main function
def main():
    # Create seed.iso
    create_seed_iso()
    # Download Ubuntu img and convert to vdi image
    download_ubuntu_img()
    # Create Virtualbox server
    create_vbox_server(args.name, args.memory, args.cpu, args.disk, args.os, args.user)

# Main function
if __name__ == '__main__':
    main()
    
# Exit
sys.exit(0)
