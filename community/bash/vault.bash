#!/bin/bash
set -euo pipefail

# This script backs up a specified directory into a tarball.

# Global variables
VAULT_PATH="tools/vault"
SERVICE="devopsvault"
LOG_FILE="vault-install.log"
VAULT_INIT_SCRIPT="/vault/config/vault-init.sh"

log_message() {
  local message="$1"
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}

vault_clean() {
  log_message "Cleaning Vault artifacts sending output and errors to log file."
  cd $VAULT_PATH && docker-compose down --volumes --remove-orphans --rmi all &> | tee -a "$LOG_FILE"

  if [ $? -eq 0 ]; then
    log_message "Vault artifacts cleaned successfully."
  else
    log_message "Error during cleaning of Vault artifacts or it was the first time running."
    return 1
  fi
}

vault_up() {
  log_message "Starting Vault."
  cd $VAULT_PATH && docker-compose up -d vault &> | tee -a "$LOG_FILE"

  if [ $? -eq 0 ]; then
    log_message "Vault is up and running successfully."
  else
    log_message "Error starting vault."
    return 1
  fi
}

vault_init() {
  log_message "Initializing Vault."
  cd $VAULT_PATH && docker cp ./vault-init.sh $(SERVICE):$VAULT_INIT_SCRIPT &> | tee -a "$LOG_FILE"
	chmod +x $VAULT_PATH/vault-init.sh &> | tee -a "$LOG_FILE"
	docker exec -it $(SERVICE) /bin/sh -c $VAULT_INIT_SCRIPT &> | tee -a "$LOG_FILE"

  if [ $? -eq 0 ]; then
    log_message "Vault has been initialized successfully."
  else
    log_message "Error during initialization of vault."
    return 1
  fi
}

vault_test() {
  log_message "Check and make sure Docker image for vault is up and running."
  docker ps | grep $(SERVICE) &> | tee -a "$LOG_FILE"

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