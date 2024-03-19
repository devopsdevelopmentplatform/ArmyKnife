#!/bin/bash


set -euo pipefail
IFS=$'\n\t'


# Global variables
VAULT_PATH="tools/vault"
SERVICE="devopsvault"
LOG_FILE="vault-install.log"
VAULT_INIT_SCRIPT="/vault/config/vault-init.sh"

cd $VAULT_PATH
exec > vault-install.log 2>&1
log_message() {
  local message="$1"
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}




vault_clean() {
  local output
  output=$(docker-compose down --volumes --remove-orphans --rmi all 2>&1) || true
  log_message "Cleaning Vault artifacts sending output and errors to log file.\n$output"

  if [ $? -eq 0 ]; then
    log_message "Vault artifacts cleaned successfully."
  else
    log_message "Error during cleaning of Vault artifacts or it was the first time running."
    return 1
  fi
}


vault_up() {
  log_message "Starting Vault."
  docker-compose up -d vault 2>&1 || true

  if [ $? -eq 0 ]; then
    log_message "Vault is up and running successfully."
  else
    log_message "Error starting vault."
    return 1
  fi
}

vault_init() {
  log_message "Initializing Vault."
  docker cp ./vault-init.sh $SERVICE:$VAULT_INIT_SCRIPT 2>&1 || true
	chmod +x vault-init.sh 2>&1 || true
	docker exec -it $SERVICE $VAULT_INIT_SCRIPT 2>&1 || true

  if [ $? -eq 0 ]; then
    log_message "Vault has been initialized successfully."
  else
    log_message "Error during initialization of vault."
    return 1
  fi
}

vault_test() {
  log_message "Check and make sure Docker image for vault is up and running."
  docker ps | grep $SERVICE 2>&1 || true

  if [ $? -eq 0 ]; then
    log_message "Vault seems to be up and running according to docker ps."
  else
    log_message "Error checking docker to see if it is up and running."
    return 1
  fi
}

main() {
  log_message "Starting Vault installation."
  vault_clean || exit 1
  vault_up || exit 1
  vault_init || exit 1
  vault_test || exit 1
  log_message "Vault installation completed successfully."
}

trap 'log_message "An unexpected error occurred."' ERR

main "$@"