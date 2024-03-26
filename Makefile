# Parent Makefile for ArmyKnife DevOps CI/CD Framework Development Environment

# Tier 1 is the base platform to get you started with your DevOps CI/CD Framework development.
# It Includes:
# - Vault
# - Ansible
# - Geodesic
# - VirtualBox
# - Vagrant
# - Docker
# - Minikube
# - ELK Stack

# Include external Makefiles for Tier 1 targets
# These are called Child or Sub Makefiles
include Makefile.Libs.mk # Not tested on MacOS
include Makefile.Vault.mk # Done
include Makefile.Git.mk # Done
include Makefile.K8s.mk # Done
include Makefile.VBox.mk # Not tested on MacOS because cloud image tools not working on MacOS.
include Makefile.Workstation.mk # Done
include Makefile.Vagrant.mk # Done
include Makefile.Geodesic.mk # Done
include Makefile.Docker.mk # Done
include Makefile.Python.mk # Done
# include Makefile.Ansible.mk
# include Makefile.Terraform.mk
# include Makefile.Packer.mk
# include Makefile.Kubeless.mk



# Define the default target when you run `make` without arguments
# Make sure that you don't overlapping targets with the same name in the child makefiles.
.DEFAULT_GOAL := help

# Phony targets
# These targets are not files, but they are commands that you want to run
# Using the .PHONY special target, it tells make that these targets are not real files.
.PHONY: help notify-user-add-secrets setup-workstation setup-vault vagrant-up connect-to-vault vagrant-destroy-all setup-git build-custom-geodesic connect-to-my-geodesic ssh-vagrant install-minikube install-kubespray create-vbox-vm ova-import build-docker-images ingest-secrets ingest-secrets-into-vault build-go-demo-app security-test-mygoapp scan-image-with-grype scan-image-with-syft scan-image-with-trivy scan-image-with-dockle lint-mygoapp-dockerfile install-and-run-notary build-docker-images-alpine-golang		

# Variables
# These are the variables that are used in the Makefile
# Makefiles have 5 types of variables. Here is an example of each. Each type has a unique assignment operator.
# 1. Simple assignment operator (=)
# 2. Recursively expanded variables (:=). This is the most common type of assignment.
# 3. Simply expanded variables (=)
# 4. Append operator (+=). Here is an example of the append operator COUNT += 1. This means COUNT = COUNT + 1.
# 5. Conditional assignment operator (?=). Here is an example of the conditional assignment operator COUNT ?= 1. This means if COUNT is not already set, then set it to 1.

ENV_FILE := .env
EXAMPLE_ENV_FILE := env_sample.txt
MESSAGE := "Please test a few of the commands before moving forward."

# Helper Targets
# These are helper targets that are used to notify the user of important information.
# You can redefine MESSAGE to be whatever you want to notify the user about.
notify-user-add-secrets:
	@echo "\033[1;33mIMPORTANT: $(MESSAGE) \033[0m"

# Target to do it all
# This target is the main target that runs all the other targets.
#all: setup-workstation setup-vault setup-git build-custom-geodesic connect-to-my-geodesic vagrant-up install-minikube install-kubespray create-vbox-vm ova-import connect-to-vault notify-user-add-secrets ingest-secrets docker-build
#	@echo "All targets completed."

################################################################################################################
# Setup Workstation MacOS and Ubuntu
################################################################################################################
# Main target for setting up the development workstation on both MacOS and Ubuntu checks to see what OS is running and runs the appropriate target
# This is just a starting point for the setup-workstation target. Later we will use a more advanced tool to install MacOS applications with Makefiles.
# This is a conditional statement that checks the OS by comparing the output of the shell command uname to the string "Darwin". 
# It translates to if Darwin = Darwin then run the following commands. The comma is used to separate the condition much like a == operator in a programming language.
setup-workstation:
ifeq ($(shell uname),Darwin) 
	@echo "Running MacOS setup"
	@$(MAKE) -d -f Makefile.Workstation.mk setup-macos
else
	@echo "Running Ubuntu setup"
	@$(MAKE) -d -f Makefile.Workstation.mk setup-ubuntu
endif

################################################################################################################
# Vault Setup
################################################################################################################
# Creates Vault environment variables and connects to Vault
# Testing the setup-vault target
# The @$(MAKE) -d -f means run the make command with the -d flag and the -f flag to specify the Makefile to use.
setup-vault:
	@echo "Setting up Vault"
	./vault.bash
	@$(MAKE) -d -f Makefile.Vault.mk connect-to-vault
	@echo "Vault setup completed."

connect-to-vault:
	@echo "Connecting to Vault"
	@$(MAKE) -d -f Makefile.Vault.mk connect-to-vault

ingest-secrets:
	@echo "Ingesting secrets into Vault"
	@$(MAKE) -d -f Makefile.Vault.mk ingest-secrets-into-vault
	@echo "Secrets ingested into Vault."


################################################################################################################
# Setup Vagrant Boxes
################################################################################################################
# Vagrant Commands Need to add the rest of the vagrant commands.
vagrant-up:
	@echo "Launching Vagrant boxes"
	@$(MAKE) -d -f Makefile.Vagrant.mk up-vagrant
	@echo "Vagrant boxes launched."

vagrant-ssh:	
	@echo "SSH into Vagrant box"
	@$(MAKE) -d -f Makefile.Vagrant.mk ssh-vagrant

vagrant-destroy-all:
	@echo "Destroying Vagrant boxes"
	@$(MAKE) -d -f Makefile.Vagrant.mk destroy-vagrant

ova-import:
	@echo "Importing OVA files"
	@$(MAKE) -d -f Makefile.VBox.mk import-ovas



################################################################################################################
# Configure Git with personal and global settings
################################################################################################################

setup-git:
	@echo "Setting up Git"
	@$(MAKE) -d -f Makefile.Git.mk setup-git-config
	@echo "Git setup completed."




################################################################################################################
# Geodesic is a toolbox for cloud automation and devops. It's a cloud shell with Terraform, Packer, Docker, kubectl and other tools installed.
################################################################################################################
# Yes we have some duplication here. We will fix this later. LOL

# Main target for building Geodesic
build-custom-geodesic:
	@echo "Building Geodesic"
	@$(MAKE) -d -f Makefile.Geodesic.mk build-geodesic
	@echo "Geodesic build completed."


connect-to-my-geodesic:
ifeq ($(shell uname), Darwin)
	@echo "Connecting to Geodesic"
	@$(MAKE) -d -f Makefile.Geodesic.mk connect-to-geodesic
else
	@echo "Connecting to Geodesic"
	@$(MAKE) -d -f Makefile.Geodesic.mk connect-to-geodesic
endif


################################################################################################################
# Download and install minikube
################################################################################################################


install-minikube:
	@echo "Downloading and starting Minikube"
	@$(MAKE) -d -f Makefile.K8s.mk configure-minikube
	@echo "Minikube download completed."

################################################################################################################
# Download and install Kubespray
################################################################################################################

install-kubespray:
	@echo "Downloading and starting Kubespray"
	@$(MAKE) -d -f Makefile.K8s.mk kubespray-install
	@echo "Kubespray install completed."

################################################################################################################
# Create a Virtualbox from scratch
################################################################################################################
# Create Virtualbox VM and connect to it. Only works on Linux right now.

ifeq ($(shell uname), Linux)
create-vbox-vm:
	@echo "Creating VirtualBox VM"
	@$(MAKE) -d -f Makefile.VBox.mk setup-vm
	@echo "VirtualBox VM created."
else
	@echo "This target only works on Linux"
endif


################################################################################################################
# Build Docker Images
################################################################################################################

# Build Docker Images
build-docker-images:
	@echo "Building Docker Images"
	@$(MAKE) -d -f Makefile.Docker.mk docker-build
	@echo "Docker Images built."

build-docker-images-alpine-golang:
	@echo "Building Docker Images"
	@$(MAKE) -d -f Makefile.Docker.mk docker-build-alpine-golang
	@echo "Docker Images built."

build-go-demo-app:
	@echo "Building Go Demo App"
	@$(MAKE) -d -f Makefile.Docker.mk build-go-demo-app
	@echo "Go Demo App built."

scan-image-with-trivy:
	@echo "Security Testing Go Demo App"
	@$(MAKE) -d -f Makefile.Docker.mk scan-with-trivy
	@echo "Security Testing completed."

scan-image-with-grype:
	@echo "Scanning Go Demo App with Grype"
	@$(MAKE) -d -f Makefile.Docker.mk scan-with-grype
	@echo "Grype scan completed."

scan-image-with-syft:
	@echo "Scanning Go Demo App with Syft"
	@$(MAKE) -d -f Makefile.Docker.mk scan-with-syft
	@echo "Syft scan completed."

scan-image-with-dockle:
	@echo "Scanning Go Demo App with Dockle"
	@$(MAKE) -d -f Makefile.Docker.mk scan-with-dockle
	@echo "Dockle scan completed."

lint-mygoapp-dockerfile:
	@echo "Linting Dockerfile"
	@$(MAKE) -d -f Makefile.Docker.mk lint-dockerfiles
	@echo "Dockerfile linted."

install-and-run-notary:
	@echo "Installing Notary"
	@$(MAKE) -d -f Makefile.Docker.mk install-notary
	@echo "Notary installed."

################################################################################################################
# Show the user a menu of options to run make commands
################################################################################################################

# Help target needs updated last when finsihed with project development
help:
	@echo ":::'###::::'########::'##::::'##:'##:::'##:'##:::'##:'##::: ##:'####:'########:'########:"
	@echo "::'## ##::: ##.... ##: ###::'###:. ##:'##:: ##::'##:: ###:: ##:. ##:: ##.....:: ##.....::"
	@echo ":'##:. ##:: ##:::: ##: ####'####::. ####::: ##:'##::: ####: ##:: ##:: ##::::::: ##:::::::"
	@echo "'##:::. ##: ########:: ## ### ##:::. ##:::: #####:::: ## ## ##:: ##:: ######::: ######:::"
	@echo "#########: ##.. ##::: ##. #: ##:::: ##:::: ##. ##::: ##. ####:: ##:: ##...:::: ##...::::"
	@echo "##.... ##: ##::. ##:: ##:.:: ##:::: ##:::: ##:. ##:: ##:. ###:: ##:: ##::::::: ##:::::::"
	@echo "##:::: ##: ##:::. ##: ##:::: ##:::: ##:::: ##::. ##: ##::. ##:'####: ##::::::: ########:"
	@echo "..:::::..::..:::::..::..:::::..:::::..:::::..::::..::..::::..::....::..::::::::........::"
	@echo "                  Armyknife Help Menu                  "
	@echo "--------------------------------------------------------"
	@echo "create-vbox-vm          - Create a custom virtualbox VM (Linux Only)"
	@echo "install-kubespray       - Install Kubernetes Cluster complete with Masters/Etcd and Workers"
	@echo "install-minikube        - Setup Kubernetes Test Environment"
	@echo "connect-to-my-geodesic  - Connect to Geodesic ToolBox Shell"
	@echo "build-custom-geodesic   - Build Geodesic Docker Image with Kali plugin"
	@echo "setup-git               - Setup Git Configuration"
	@echo "vagrant-up              - Launch Vagrant Box Jammy (Ansible)"
	@echo "setup-workstation       - Install OS Packages and Tools"
	@echo "setup-vault             - Create Vault Server for Development"
	@echo "--------------------------------------------------------"
	@echo "Use \"make <target>\" to run a specific command."



