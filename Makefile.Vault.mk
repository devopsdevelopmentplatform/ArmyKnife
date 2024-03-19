

.PHONY: vault-up vault-down vault-clean vault-connect ingest-secrets-into-vault test-vault-secret print-vault-secrets test-vault-login

# Define variables
SERVICE=devopsvault
MESSAGE := "Vault has been installed. Please test a few of the commands before moving forward"
VAULT_TOKEN := $(echo .env | grep VAULT_TOKEN | cut -d '=' -f2)

# Default target
all: clean-vault vault-up init-vault notify-user

# Heler Targets
notify-user:
	@echo "\033[1;33mIMPORTANT: $(MESSAGE) \033[0m"

# Stop the vault service
vault-clean:
	cd tools/vault && docker-compose down --volumes --remove-orphans --rmi all

# Start the vault service using docker-compose
vault-up:
	cd tools/vault && docker-compose up -d vault
	
# Initialize vault (executes vault-init.sh inside the running container)
init-vault:
	cd tools/vault && docker cp ./vault-init.sh $(SERVICE):/vault/config/vault-init.sh
	chmod +x ./tools/vault/vault-init.sh
	docker exec -it $(SERVICE) /bin/sh -c "/vault/config/vault-init.sh"
	
vault-connect:
	ifeq ($(shell uname), Darwin)
		open -a Terminal /bin/zsh -c "docker exec -it devopsvault /bin/sh"
	else
		gnome-terminal -- /bin/bash -c "docker exec -it devopsvault /bin/sh"
	endif

connect-to-vault:
ifeq ($(shell uname), Darwin)
	osascript -e 'tell app "Terminal" to do script "docker exec -it devopsvault /bin/sh"'
else
	docker start devopsvault && gnome-terminal -- /bin/bash -c "docker exec -it devopsvault /bin/sh"
endif


# Target to ingest secrets into HashiCorp Vault using Vault CLI for KV version 2
ingest-secrets-into-vault:
	export VAULT_ADDR=http://127.0.0.1:8200 && \
	export VAULT_TOKEN=$$(cat .env | grep VAULT_TOKEN | cut -d '=' -f2) && \
	while read -r line; do \
		secret_path=$$(echo $$line | cut -d '=' -f 1); \
		secret_value=$$(echo $$line | cut -d '=' -f 2); \
		vault kv put --mount="kv" $$secret_path $$secret_path="$$secret_value"; \
		echo "Ingested $$secret_path into Vault"; \
	done < .env
	@echo "All secrets ingested into Vault."

# Target to test a specific secret from Vault
# Usage: make test-vault-secret SECRET_NAME=<secret-name>
test-vault-secret:
	@vault kv get -field=value kv/$(SECRET_NAME)

# Target to print all secrets from Vault
print-vault-secrets:
	@vault kv list kv/

# Test Vault Login from outside this Makefile
test-vault-login:
	@./libraries/bash/vault_login.sh
	@echo "Vault login successful."
	@vault kv list kv/


vault-down:
	cd tools/vault && docker-compose down
# Rebuild the vault service
rebuild:
	cd tools/vault && docker-compose up -d --build $(SERVICE)




