#!/bin/bash

export RG_NAME="nc-infra"
export STORAGE_ACCOUNT_NAME="ncinfrastorage"
export CONTAINER_NAME="pulumi-state"
export AZURE_KEYVAULT_AUTH_VIA_CLI=true

set -e 

Green='\033[0;32m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
Red='\033[0;31m'
NC='\033[0m'

echo "${Yellow}Login to Azure CLI using${NC} az login ${Yellow}before running${NC}"

azGetSA()
{
	export KEYS=$(az storage account keys list --account-name $STORAGE_ACCOUNT_NAME --resource-group $RG_NAME --output json)
	export AZURE_STORAGE_ACCOUNT=$STORAGE_ACCOUNT_NAME
	export AZURE_STORAGE_KEY=$(echo $KEYS | jq -r .[0].value)
	export AZURE_KEYVAULT_AUTH_VIA_CLI=true
}

azLogin() 
{
	pulumi login --cloud-url azblob://$CONTAINER_NAME
}

echo "${Green}Enter folder of existing project: \\ne.g ${NC} $PWD/<folder name> ${NC}"
read EXISTING_PROJ
cd $EXISTING_PROJ

echo "Enter command to run:"
read RUN_CMD
azGetSA
azLogin
echo "Running... $RUN_CMD"
$RUN_CMD
