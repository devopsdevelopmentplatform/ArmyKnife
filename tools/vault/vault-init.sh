#!/bin/sh

# Export values
export VAULT_ADDR='http://0.0.0.0:8200'
export VAULT_SKIP_VERIFY='true'


# Initialize Vault and output keys to a file
vault operator init -key-shares=1 -key-threshold=1 > generated_keys.txt

# Parse unseal key
unsealKey=$(grep 'Unseal Key 1:' generated_keys.txt | cut -d' ' -f4)

# Unseal Vault
vault operator unseal $unsealKey

# Get root token
rootToken=$(grep 'Initial Root Token:' generated_keys.txt | cut -d' ' -f4)
echo $rootToken > root_token.txt

export VAULT_TOKEN=$rootToken

vault login $rootToken
# Enable kv
vault secrets enable -version=2 kv

# Enable userpass and add default user
vault auth enable userpass

vault write auth/userpass/users/admin password="s3cr3t" policies=default

# Add test value to my-secret
vault kv put kv/my-secret my-value=s3cr3t


