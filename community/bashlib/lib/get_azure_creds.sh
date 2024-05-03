function get_vault_credentials() {
    if ! command -v vault &> /dev/null; then
        echo "Vault command line tool is not installed. Please install it manually."
        return 1
    fi
    response=$(vault kv get --mount="kv" Cloud/Azure)
    azure_client_id=$(echo "$response" | awk '/appId/ {print $2}')
    azure_client_secret=$(echo "$response" | awk '/password/ {print $2}')
    azure_subscription_id=$(echo "$response" | awk '/subscription/ {print $2}')
    azure_tenant_id=$(echo "$response" | awk '/tenant/ {print $2}')
    export AZURE_CLIENT_ID=$azure_client_id
    export AZURE_CLIENT_SECRET=$azure_client_secret
    export AZURE_SUBSCRIPTION_ID=$azure_subscription_id
    export AZURE_TENANT_ID=$azure_tenant_id
}
