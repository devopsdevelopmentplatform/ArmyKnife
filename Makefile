# Parent Makefile for ArmyKnife DevOps CI/CD Framework Development Environment



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
include Makefile.Ansible.mk
include Makefile.Terraform.mk
include Makefile.Packer.mk
include Makefile.CICD.mk
include Makefile.Setup.mk
include Makefile.K8s-Admin.mk
include Makefile.ELK.mk
include Makefile.Security.mk
include Makefile.BashLib.mk
include Makefile.Registry.mk














################################################################################################################
# Show the user a menu of options to run make commands
################################################################################################################

# Help target needs updated last when finsihed with project development
.PHONY: help
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



