# Makefile for setting up a Bash library structure

# Variables
LIB_DIR = ~/bashlib/lib
BIN_DIR = ~/bashlib/bin
STRING_OPS = $(LIB_DIR)/string_operations.sh
MATH_OPS = $(LIB_DIR)/math_operations.sh
VAULT_OPS = $(LIB_DIR)/get_azure_creds.sh
MAIN_LIB = $(LIB_DIR)/main.sh
EXAMPLE_SCRIPT = $(BIN_DIR)/example_script.sh

# Default target
all: setup-lib setup-bin setup-main setup-example

# Set up library directories
setup-lib:
	mkdir -p $(LIB_DIR)
	touch $(STRING_OPS)
	echo 'function string_length() {' >> $(STRING_OPS)
	echo '    echo "$${#1}"' >> $(STRING_OPS)
	echo '}' >> $(STRING_OPS)
	echo '' >> $(STRING_OPS)
	echo 'function string_reverse() {' >> $(STRING_OPS)
	echo '    echo "$$1" | rev' >> $(STRING_OPS)
	echo '}' >> $(STRING_OPS)
	touch $(MATH_OPS)
	echo 'function math_add() {' >> $(MATH_OPS)
	echo '    echo "$$(( $$1 + $$2 ))"' >> $(MATH_OPS)
	echo '}' >> $(MATH_OPS)
	echo '' >> $(MATH_OPS)
	echo 'function math_subtract() {' >> $(MATH_OPS)
	echo '    echo "$$(( $$1 - $$2 ))"' >> $(MATH_OPS)
	echo '}' >> $(MATH_OPS)
	touch $(VAULT_OPS)
	echo 'function get_vault_credentials() {' >> $(VAULT_OPS)
	echo '    if ! command -v vault &> /dev/null; then' >> $(VAULT_OPS)
	echo '        echo "Vault command line tool is not installed. Please install it manually."' >> $(VAULT_OPS)
	echo '        return 1' >> $(VAULT_OPS)
	echo '    fi' >> $(VAULT_OPS)
	echo '    response=$$(vault kv get --mount="kv" Cloud/Azure)' >> $(VAULT_OPS)
	echo '    azure_client_id=$$(echo "$$response" | awk '\''/appId/ {print $$2}'\'')' >> $(VAULT_OPS)
	echo '    azure_client_secret=$$(echo "$$response" | awk '\''/password/ {print $$2}'\'')' >> $(VAULT_OPS)
	echo '    azure_subscription_id=$$(echo "$$response" | awk '\''/subscription/ {print $$2}'\'')' >> $(VAULT_OPS)
	echo '    azure_tenant_id=$$(echo "$$response" | awk '\''/tenant/ {print $$2}'\'')' >> $(VAULT_OPS)
	echo '    export AZURE_CLIENT_ID=$$azure_client_id' >> $(VAULT_OPS)
	echo '    export AZURE_CLIENT_SECRET=$$azure_client_secret' >> $(VAULT_OPS)
	echo '    export AZURE_SUBSCRIPTION_ID=$$azure_subscription_id' >> $(VAULT_OPS)
	echo '    export AZURE_TENANT_ID=$$azure_tenant_id' >> $(VAULT_OPS)
	echo '}' >> $(VAULT_OPS)

# Set up bin directory
setup-bin:
	mkdir -p $(BIN_DIR)

# Set up main library file
setup-main:
	touch $(MAIN_LIB)
	echo '# Source all library files' >> $(MAIN_LIB)
	echo 'source "$$(dirname "$${BASH_SOURCE[0]}")/string_operations.sh"' >> $(MAIN_LIB)
	echo 'source "$$(dirname "$${BASH_SOURCE[0]}")/math_operations.sh"' >> $(MAIN_LIB)
	echo 'source "$$(dirname "$${BASH_SOURCE[0]}")/get_azure_creds.sh"' >> $(MAIN_LIB)

# Set up example script
setup-example:
	touch $(EXAMPLE_SCRIPT)
	echo '#!/bin/bash' >> $(EXAMPLE_SCRIPT)
	echo '' >> $(EXAMPLE_SCRIPT)
	echo '# Source the main library file' >> $(EXAMPLE_SCRIPT)
	echo 'source "$$(dirname "$$0")/../lib/main.sh"' >> $(EXAMPLE_SCRIPT)
	echo '' >> $(EXAMPLE_SCRIPT)
	echo '# Use the library functions' >> $(EXAMPLE_SCRIPT)
	echo 'len=$$(string_length "hello")' >> $(EXAMPLE_SCRIPT)
	echo 'echo "Length of '\''hello'\'': $$len"' >> $(EXAMPLE_SCRIPT)
	echo '' >> $(EXAMPLE_SCRIPT)
	echo 'sum=$$(math_add 5 3)' >> $(EXAMPLE_SCRIPT)
	echo 'echo "Sum of 5 and 3: $$sum"' >> $(EXAMPLE_SCRIPT)
	chmod +x $(EXAMPLE_SCRIPT)

.PHONY: all setup-lib setup-bin setup-main setup-example
