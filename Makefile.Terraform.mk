# Define variables for Terraform commands
TERRAFORM := terraform
ENV ?= default
PLAN := plan-$(ENV).tfplan

# Directory for environment-specific configurations
CONFIG_DIR := environments/$(ENV)

# Default Terraform options
TF_INIT_OPTS := -reconfigure
TF_PLAN_OPTS := -input=false
TF_APPLY_OPTS := -input=false
TF_DESTROY_OPTS := -auto-approve

# Helper function to run Terraform commands in the context of an environment
define terraform-cmd
	cd $(CONFIG_DIR) && $(TERRAFORM) $(1) $(if $(filter $(1),apply destroy),,$(TF_INIT_OPTS)) $(2)
endef

# Phony targets for standard Terraform workflow
.PHONY: init plan apply destroy validate fmt output

# Initialize Terraform
init:
	@$(call terraform-cmd,init)

# Create a Terraform plan
plan:
	@$(call terraform-cmd,plan,$(TF_PLAN_OPTS) -out=$(PLAN))

# Apply a Terraform plan
apply:
	@$(call terraform-cmd,apply,$(TF_APPLY_OPTS) $(PLAN))

# Destroy Terraform-managed infrastructure
destroy:
	@$(call terraform-cmd,destroy,$(TF_DESTROY_OPTS))

# Validate Terraform files
validate:
	@$(call terraform-cmd,validate)

# Format Terraform files
fmt:
	@$(call terraform-cmd,fmt -recursive)

# Show output
output:
	@$(call terraform-cmd,output)

# Example usage:
# make init ENV=dev
# make plan ENV=dev
# make apply ENV=dev
# make destroy ENV=dev
