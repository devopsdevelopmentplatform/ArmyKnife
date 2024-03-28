# Sub Makefile for VirtualBox VM Setup

# Variables
SCRIPT_PATH := ../../create_vbox.sh
VM_NAME ?= ubuntu 
VM_IP ?= 192.168.50.207
CPU_CORES ?= 1
MEMORY ?= 4096
DISK_SIZE ?= 12000
UBUNTU_RELEASE ?= 22.04
SCRIPT_BASE_DIR := ./tools/vbox/servers
VM_WORKING_DIR := $(SCRIPT_BASE_DIR)/$(VM_NAME)
OVA_DIR := ./tools/vbox/ova
SUFFIX := $(shell date +%Y%m%d%H%M%S)



# Phony targets for VM setup
.PHONY: setup-vm create-vm-dir run-vbox-setup-script import-ovas

# Default target for setting up VM
setup-vm: run-vbox-setup-script

connect-ansible:
	@echo "Connecting to Ansible"
	@cd $(SCRIPT_BASE_DIR) && vagrant ssh
	
import-ovas:
	@echo "Downloading OVA files"
	mkdir -p tools/vbox/ova
	@cd $(OVA_DIR) && wget https://bitnami.com/redirect/to/2407501/bitnami-gitlab-ce-16.7.0-ce.0-r0-debian-11-amd64.ova && \
  wget https://bitnami.com/redirect/to/2408461/bitnami-gitea-1.21.3-r1-debian-11-amd64.ova && \
  wget https://bitnami.com/redirect/to/2407822/bitnami-jenkins-2.426.2-r1-debian-11-amd64.ova && \
  wget https://bitnami.com/redirect/to/2409741/bitnami-elk-8.11.4-r0-debian-11-amd64.ova
	@echo "Importing OVA files from $(OVA_DIR)"
	@for ova in $(OVA_DIR)/*.ova; do \
		vmname=$$(basename "$$ova" .ova)-$(SUFFIX); \
		echo "Importing $$ova as $$vmname"; \
		VBoxManage import "$$ova" --vsys 0 --vmname "$$vmname" --eula accept; \
	done


# Target to run the setup script
run-vbox-setup-script:
	@echo "Running VM setup script for $(VM_NAME)"
	python3 community/python/create_server_ubuntu.py --name ansible --memory 2048 --cpu 1 --disk 10096 --os Ubuntu_64 --user ansible --folder ansible 
	# python3 community/python/create_server_ubuntu.py --name ansible --memory 4096 --cpu 2 --disk 124096 --os Ubuntu_64 --user ubuntu --folder ansible
