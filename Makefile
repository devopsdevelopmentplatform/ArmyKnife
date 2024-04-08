# Parent Makefile for ArmyKnife DevOps CI/CD Framework Development Environment



include Makefile.Libs.mk # Not tested on MacOS
include Makefile.Vault.mk # Done Stable on Linux and MacOS
include Makefile.Git.mk # Done Stable on Linux and MacOS
include Makefile.K8s.mk # Done
include Makefile.VBox.mk # Not tested on MacOS because cloud image tools not working on MacOS.
include Makefile.Workstation.mk # Done stable on Linux and MacOS
include Makefile.Vagrant.mk # Done
include Makefile.Geodesic.mk # Done Stable on Linux and MacOS
include Makefile.Docker.mk # Done
include Makefile.Python.mk # Done
include Makefile.Ansible.mk # Needs more testing
include Makefile.Terraform.mk # Needs Tested
include Makefile.Packer.mk # WIP
include Makefile.CICD.mk # WIP
include Makefile.Setup.mk # WIP
include Makefile.K8s-Admin.mk # WIP but smoke test is working on Linux
include Makefile.ELK.mk # WIP
include Makefile.Security.mk # WIP
include Makefile.BashLib.mk # Needs Testing on MacOS
include Makefile.Registry.mk # Needs reworked for MacOS option














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



