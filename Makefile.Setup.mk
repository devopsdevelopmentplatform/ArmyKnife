# Define the default target when you run `make` without arguments
# Make sure that you don't overlapping targets with the same name in the child makefiles.
.DEFAULT_GOAL := help

# Phony targets
# These targets are not files, but they are commands that you want to run
# Using the .PHONY special target, it tells make that these targets are not real files.
.PHONY: help notify-user-add-secrets setup-workstation setup-vault vagrant-up connect-to-vault vagrant-destroy-all setup-git build-custom-geodesic connect-to-my-geodesic ssh-vagrant install-minikube install-kubespray create-vbox-vm ova-import build-docker-images ingest-secrets ingest-secrets-into-vault build-go-demo-app security-test-mygoapp scan-image-with-grype scan-image-with-syft scan-image-with-trivy scan-image-with-dockle lint-mygoapp-dockerfile install-and-run-notary build-docker-images-alpine-golang build-cloud-cli-image test-cloud-cli-image login-to-registries push-cloud-cli-image-to-registries run-local build-python-demo-app k8s-smoke-test		

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
    #@$(MAKE) -d -f Makefile.Vault.mk connect-to-vault
	@echo "Vault setup completed."

# connect-to-vault:
# 	@echo "Connecting to Vault"
# 	@$(MAKE) -d -f Makefile.Vault.mk connect-to-vault

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

k8s-smoke-test:
	@echo "Running smoke test..."
	@$(MAKE) -f Makefile.K8s.mk kubespray-up
	@$(MAKE) -f Makefile.K8s-Admin.mk smoke-test
	@echo "Smoke test completed."

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

# build-go-demo-app:
# 	@echo "Building Go Demo App"
# 	@$(MAKE) -d -f Makefile.Docker.mk build-go-demo-app
# 	@echo "Go Demo App built."

# build-python-demo-app:
# 	@echo "Building Python Demo App"
# 	@$(MAKE) -d -f Makefile.Docker.mk build-python-demo-app
# 	@echo "Python Demo App built."

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
# Build Cloud CICD Image for Pipelines
################################################################################################################

# We need to build fresh images often and run local to test them

build-cloud-cli-image:
	@echo "Building Cloud CLI Image"
	@$(MAKE) -d -f Makefile.CICD.mk build_cloud_cli_image
	@echo "Cloud CLI Image built."

test-cloud-cli-image:
	@echo "Testing Cloud CLI Image"
	@$(MAKE) -d -f Makefile.CICD.mk test_cloud_cli_image
	@echo "Cloud CLI Image tested."

login-to-registries:
	@echo "Logging into Docker Registries"
	@$(MAKE) -d -f Makefile.CICD.mk login_to_registries
	@echo "Logged into Docker Registries."

push-cloud-cli-image-to-registries:	
	@echo "Pushing Cloud CLI Image to Registries"
	@$(MAKE) -d -f Makefile.CICD.mk push_cloud_cli_image_to_registries
	@echo "Cloud CLI Image pushed to Registries."

run-local:
	@echo "Running Cloud CLI Image locally"
	@$(MAKE) -d -f Makefile.CICD.mk run_local
	@echo "Cloud CLI Image running locally."
