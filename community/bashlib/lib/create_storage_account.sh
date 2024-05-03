#!/bin/bash
setup_azure_terraform_backend() {
    # Set variables

    # Get Azure Creds from Vault
    get_vault_credentials
    
    resource_group_name="$1"
    storage_account_name="$2"
    container_name="$3"
    location="eastus"
    # Create resource group
    az group create --name $resource_group_name --location $location
    # Create storage account
    az storage account create --name $storage_account_name --resource-group $resource_group_name --location $location --sku Standard_LRS
    # Get storage account key
    storage_account_key=$(az storage account keys list --account-name $storage_account_name --resource-group $resource_group_name --query "[0].value" --output tsv)
    # Create container
    az storage container create --name $container_name --account-name $storage_account_name --account-key $storage_account_key
    # Print connection string
    connection_string=$(az storage account show-connection-string --name $storage_account_name --resource-group $resource_group_name --output tsv)
    echo "Azure Storage Account Connection String: $connection_string"
}

#!/bin/bash

# Help message function
show_help() {
    echo "Usage: create_azure_storage_backend <resource_group_name> <storage_account_name> <container_name>"
    echo
    echo "This function sets up an Azure storage backend for Terraform."
    echo "It requires three arguments:"
    echo "  resource_group_name    - The name of the Azure resource group."
    echo "  storage_account_name   - The name of the Azure storage account."
    echo "  container_name         - The name of the Azure storage container."
}

# Function to create an Azure storage backend
create_azure_terraform_backend() {
    if [ "$#" -ne 3 ]; then
        echo "Error: Incorrect number of arguments provided. Also remember that location is hardcoded in the bash function"
        show_help
        return 1
    fi
    

    # Set variables
    resource_group_name="$1"
    storage_account_name="$2"
    container_name="$3"

    # Call the setup function (ensure this is defined or replace with actual command)
    setup_azure_terraform_backend "$resource_group_name" "$storage_account_name" "$container_name"
}


# Check if the script is being run directly and provide help if no arguments are given
if [ "${BASH_SOURCE[0]}" == "${0}" ] && [ "$#" -eq 0 ]; then
    show_help
fi