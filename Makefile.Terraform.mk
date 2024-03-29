# Define variables for Terraform commands
TERRAFORM := terraform
ENV ?= dev
PLAN := plan-$(ENV).tfplan

# Directory for environment-specific configurations
CONFIG_DIR := tools/terraform/Docker_Build

# Default Terraform options
TF_INIT_OPTS := -reconfigure
TF_PLAN_OPTS := -input=false
TF_APPLY_OPTS := -input=false
TF_DESTROY_OPTS := -auto-approve

# Helper function to run Terraform commands in the context of an environment
define terraform-cmd
	@if [ "$(1)" = "init" ]; then \
		cd $(CONFIG_DIR) && $(TERRAFORM) $(1) $(TF_INIT_OPTS) $(2); \
	elif [ "$(1)" = "apply" ] || [ "$(1)" = "destroy" ]; then \
		cd $(CONFIG_DIR) && $(TERRAFORM) $(1) $(2); \
	else \
		cd $(CONFIG_DIR) && $(TERRAFORM) $(1) $(2); \
	fi
endef

# Phony targets for standard Terraform workflow
.PHONY: terraform-init terraform-plan terraform-apply terraform-destroy terraform-validate terraform-fmt terraform-output

# Initialize Terraform
terraform-init:
	@$(call terraform-cmd,init,$(TF_INIT_OPTS))

# Create a Terraform plan
terraform-plan:
	@$(call terraform-cmd,plan,$(TF_PLAN_OPTS) -out=$(PLAN))

# Apply a Terraform plan
terraform-apply:
	@$(call terraform-cmd,apply,$(TF_APPLY_OPTS) $(PLAN))

# Destroy Terraform-managed infrastructure
terraform-destroy:
	@$(call terraform-cmd,destroy,$(TF_DESTROY_OPTS))

# Validate Terraform files
terraform-validate:
	@$(call terraform-cmd,validate)

# Format Terraform files
terraform-fmt:
	@$(call terraform-cmd,fmt -recursive)

# Show output
terraform-output:
	@$(call terraform-cmd,output)

# Example usage:
# make init ENV=dev
# make plan ENV=dev
# make apply ENV=dev
# make destroy ENV=dev
