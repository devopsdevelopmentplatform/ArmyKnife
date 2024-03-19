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
include Makefile.Libs.mk # Not tested on MacOS
include Makefile.Vault.mk # Done
include Makefile.Git.mk # Done
include Makefile.K8s.mk # Done
include Makefile.VBox.mk # Not tested on MacOS because cloud image tools not working on MacOS.
include Makefile.Workstation.mk # Done
include Makefile.Vagrant.mk # Done
include Makefile.Geodesic.mk # Done


# Define the default target when you run `make` without arguments
.DEFAULT_GOAL := help

# Phony targets
.PHONY: help notify-user-add-secrets setup-workstation setup-vault vagrant-up connect-to-vault vagrant-destroy-all setup-git build-geodesic connect-to-geodesic ssh-vagrant download-minikube

# Variables
ENV_FILE := .env
EXAMPLE_ENV_FILE := env_sample.txt
MESSAGE := "Please test a few of the commands before moving forward."

# Heler Targets
notify-user-add-secrets:
	@echo "\033[1;33mIMPORTANT: $(MESSAGE) \033[0m"



# Main target for setting up the development workstation on both MacOS and Ubuntu checks to see what OS is running and runs the appropriate target
# Testing the setup-workstation target
# Everything tested and working but I'm thinking about changing it back to zsh.

setup-workstation:
ifeq ($(shell uname),Darwin)
	@echo "Running MacOS setup"
	@$(MAKE) -d -f Makefile.Workstation.mk setup-macos
else
	@echo "Running Ubuntu setup"
	@$(MAKE) -d -f Makefile.Workstation.mk setup-ubuntu
endif

# Creates Vault environment variables and connects to Vault
# Testing the setup-vault target
setup-vault:
	@echo "Setting up Vault"
	./vault.bash
	@$(MAKE) -d -f Makefile.Vault.mk connect-to-vault
	@echo "Vault setup completed."

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



# Configure Git with personal and global settings
setup-git:
	@echo "Setting up Git"
	@$(MAKE) -d -f Makefile.Git.mk setup-git-config
	@echo "Git setup completed."


# Main target for building Geodesic
build-geodesic:
	@echo "Building Geodesic"
	@$(MAKE) -d -f Makefile.Geodesic.mk build-geodesic
	@echo "Geodesic build completed."


# Connect to Geodesic
connect-to-geodesic:
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


download-minikube:
	@echo "Downloading and starting Minikube"
	@$(MAKE) -d -f Makefile.K8s.mk configure-minikube
	@echo "Minikube download completed."




# Create Virtualbox VM and connect to it. Only works on Linux right now.

ifeq ($(shell uname), Linux)
create-vbox-vm:
	@echo "Creating VirtualBox VM"
	@$(MAKE) -d -f Makefile.VBox.mk setup-vm
	@echo "VirtualBox VM created."
else
	@echo "This target only works on Linux"
endif





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
	@echo "setup           - Set up the environment (libraries and vault)"
	@echo "build           - Build the project"
	@echo "test            - Run tests"
	@echo "clean           - Clean up the environment"
	@echo "help            - Display this help"
	@echo "libraries       - Set up libraries"
	@echo "vault           - Set up and initialize vault"
	@echo "github-install-gh-cli - Install GitHub CLI"
	@echo "documentation   - Generate project documentation"
	@echo "--------------------------------------------------------"
	@echo "Use \"make <target>\" to run a specific command."



