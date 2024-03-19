# Variables
VAGRANT := vagrant
VAGRANT_FILE := tools/vagrant/Vagrantfile
BOXES := $(wildcard $(VAGRANT_FILE).*)
LOCATION := tools/vagrant
BOX := jammy

# Phony Targets
.PHONY: all help up-vagrant destroy-vagrant ssh-vagrant status-vagrant

# Default Target
all: up-vagrant ssh-vagrant status-vagrant

# Target to launch Vagrant boxes
up-vagrant:
ifdef BOX
	cd $(LOCATION) && $(VAGRANT) plugin install vagrant-vbguest && $(VAGRANT) plugin install vagrant-hostmanager
	cd $(LOCATION) && $(VAGRANT) up --provider=virtualbox $(BOX)
else
	cd $(LOCATION) && $(foreach box,$(BOXES),$(VAGRANT) up --provider=virtualbox -f $(box);)
endif

# Target to destroy Vagrant boxes
destroy-vagrant:
ifdef BOX
	cd $(LOCATION) && $(VAGRANT) destroy -f $(BOX)
else
	cd $(LOCATION) && $(foreach box,$(BOXES),$(VAGRANT) global-status;)
endif

# Target to SSH into a specific Vagrant box
ssh-vagrant:
ifdef BOX
	cd $(LOCATION) && $(VAGRANT) ssh $(BOX)
else
	@echo "Please specify the box name to SSH into. Example: make ssh BOX=mybox"
endif

# Target to show status of Vagrant boxes
status-vagrant:
	cd $(LOCATION) && $(VAGRANT) status
	
# Help Target
# help:
# 	@echo "Usage: make [TARGET]"
# 	@echo ""
# 	@echo "Targets:"
# 	@echo "  up [BOX]          Launch Vagrant boxes (all or specify BOX)"
# 	@echo "  destroy [BOX]     Destroy Vagrant boxes (all or specify BOX)"
# 	@echo "  ssh [BOX]         SSH into a Vagrant box (specify BOX)"
# 	@echo "  status            Show status of Vagrant boxes"