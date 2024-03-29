# Define variables for common paths and options
ANSIBLE_PLAYBOOK := ansible-playbook
ANSIBLE_LINT := ansible-lint
INVENTORY := inventory
LIMIT ?= all
VAULT_ID ?= @prompt
EXTRA_VARS :=
TAGS :=
SKIP_TAGS :=

# Macro for running ansible-playbook with common parameters
define RUN_ANSIBLE
	$(ANSIBLE_PLAYBOOK) -i $(INVENTORY)/$(1) --limit $(LIMIT) \
		--vault-id $(VAULT_ID) $(if $(EXTRA_VARS),-e "$(EXTRA_VARS)",) \
		$(if $(TAGS),--tags "$(TAGS)",) $(if $(SKIP_TAGS),--skip-tags "$(SKIP_TAGS)",) $(2)
endef

# Macro for ansible-lint
define RUN_LINT
	$(ANSIBLE_LINT) $(1)
endef

# Targets
.PHONY: ansible-lint syntax check deploy

# Linting your playbooks
ansible-lint:
	@$(call RUN_LINT,.)

# Check the syntax of your playbook
syntax:
	@$(call RUN_ANSIBLE,$(ENV),$(PLAYBOOK) --syntax-check)

# Run your playbook in check mode
check:
	@$(call RUN_ANSIBLE,$(ENV),$(PLAYBOOK) --check)

# Deploy your playbook
deploy:
	@$(call RUN_ANSIBLE,$(ENV),$(PLAYBOOK))

# Example usage:
# make lint
# make syntax ENV=staging PLAYBOOK=site.yml
# make check ENV=production PLAYBOOK=site.yml LIMIT=webserver EXTRA_VARS="some_var=some_value"
# make deploy ENV=production PLAYBOOK=site.yml
