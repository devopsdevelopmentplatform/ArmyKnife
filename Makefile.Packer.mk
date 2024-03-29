# Define variables
PACKER := packer
TEMPLATE_DIR := templates
BUILD_DIR := builds
TEMPLATE ?= default.pkr.hcl
VAR_FILE ?= variables.pkrvars.hcl
ONLY ?= 
EXCEPT ?=

# Helper function for Packer commands
define packer-cmd
	cd $(TEMPLATE_DIR) && $(PACKER) $(1) \
		-var-file=$(VAR_FILE) $(if $(ONLY),-only=$(ONLY),) $(if $(EXCEPT),-except=$(EXCEPT),) \
		$(TEMPLATE)
endef

# Phony targets for Packer operations
.PHONY: packer-validate packer-build packer-format packer-inspect

# Validate the Packer template
packer-validate:
	@$(call packer-cmd,validate)

# Build the image(s) from the Packer template
packer-build:
	@$(call packer-cmd,build)

# Format Packer template files
packer-format:
	@$(call packer-cmd,fmt -recursive $(BUILD_DIR))

# Inspect a Packer template
packer-inspect:
	@$(call packer-cmd,inspect)

# Example usage:
# make validate TEMPLATE=app.pkr.hcl VAR_FILE=app.auto.pkrvars.hcl
# make build TEMPLATE=app.pkr.hcl VAR_FILE=app.auto.pkrvars.hcl ONLY=amazon-ebs
# make format
# make inspect TEMPLATE=app.pkr.hcl
