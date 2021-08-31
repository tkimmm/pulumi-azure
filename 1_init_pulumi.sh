#!/bin/bash

## Update these environmental variables
# Enter geolocation
export LOCATION="westeurope"
# Enter resource group name
export RG_NAME="nc-infra"
# Enter name of master project
export PROJECT_NAME="nc-infra"
# Enter name of master project storage account
export STORAGE_ACCOUNT_NAME="ncinfrastorage"
# Enter name of master project key vault
export AZURE_KEY_VAULT_NAME="ncinfrademokv"
# Enter project language e.g azure-python aws-typescript azure-typescript
export PROJ_LANG="azure-typescript"

set -e 

Green='\033[0;32m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
Red='\033[0;31m'
NC='\033[0m'

export CONTAINER_NAME="pulumi-state"
export AZURE_KEYVAULT_AUTH_VIA_CLI=true

echo "${Yellow}Login to Azure CLI using${NC} az login ${Yellow}before running${NC}"


azGetSA()
{
	export KEYS=$(az storage account keys list --account-name $STORAGE_ACCOUNT_NAME --resource-group $RG_NAME --output json)
	export AZURE_STORAGE_ACCOUNT=$STORAGE_ACCOUNT_NAME
	export AZURE_STORAGE_KEY=$(echo $KEYS | jq -r .[0].value)
	export AZURE_KEYVAULT_AUTH_VIA_CLI=true
	export USER_OBJECT_ID=$(az ad signed-in-user show --query objectId -o tsv)
}

azLogin() 
{
	pulumi login --cloud-url azblob://$CONTAINER_NAME
}

PS3="$(echo ${Green}Please enter your choice: \\nUse Enter Key to View Options \\nor CTRL-C to exit \\n${NC})"
options=("Create Master Project" "Create new project" "Deploy existing project" "Destroy existing project")

select opt in "${options[@]}"
do
    case $opt in
        "Create Master Project")
            echo "${Blue}Checking for existing resource group $RG_NAME... ${NC}"
	    export RG_EXISTS=$(az group exists -n $RG_NAME)
	    if [[ $PULUMI_KEY_EXISTS -eq 'true' ]]
	    then 
		    echo "${Blue}Resource group $RG_NAME found skipping... ${NC}"

	    else
            echo "${Blue}Creating resource group $RG_NAME... ${NC}"
	    az group create -l $LOCATION -n $RG_NAME

            echo "${Blue}Creating storage account $STORAGE_ACCOUNT_NAME in $RG_NAME... ${NC}"
	    export SA=$(az storage account create --name $STORAGE_ACCOUNT_NAME --resource-group $RG_NAME --location westeurope --sku standard_lrs --access-tier hot --https-only true --kind storagev2)
	    export NEWKEY=$(az storage account keys list --account-name $STORAGE_ACCOUNT_NAME --resource-group $RG_NAME --output json)
	    export AZ_NEW_KEY=$(echo $NEWKEY | jq -r .[0].value)
	    az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $AZ_NEW_KEY
	    fi

	    echo "${Blue}Checking for existing key pulumi-key in $AZURE_KEY_VAULT_NAME... ${NC}"
	    PULUMI_KEY_EXISTS=$(az keyvault key show --vault $AZURE_KEY_VAULT_NAME --name pulumi-key --query "attributes.enabled")

	    if [[ $PULUMI_KEY_EXISTS -eq 'true' ]]
	    then
		    echo "${Blue}Key found skipping...${NC}"
	    else
		    echo "${Blue}Creating Azure Key Vault $AZURE_KEY_VAULT_NAME in $RG_NAME... ${NC}"
		    az keyvault create -n $AZURE_KEY_VAULT_NAME --location $LOCATION --resource-group $RG_NAME 
		    # Optional operations on the keyvault 
		    #--ops decrypt encrypt export import sign unwrapKey verify wrapKey

		    echo "${Blue}Creating encryption key (pulumi-key) in $AZURE_KEY_VAULT_NAME... ${NC}"
		    az keyvault key create --vault-name $AZURE_KEY_VAULT_NAME -n pulumi-key

		    echo "${Blue}Setting policy on encryption key (pulumi-key) in $AZURE_KEY_VAULT_NAME... ${NC}"
		    azGetSA
		    az keyvault set-policy -n $AZURE_KEY_VAULT_NAME --object-id $USER_OBJECT_ID --resource-group $RG_NAME --certificate-permissions create delete get import list restore update --key-permissions decrypt encrypt get list update create import delete recover backup restore --resource-group $RG_NAME --secret-permissions delete get list purge recover restore
	    fi
            ;;
        "Create new project")
	    echo "${Green}Enter new project name:${NC}"
	    read NEW_PROJECT_NAME
	    azGetSA
	    azLogin
	    echo "${Blue}Creating project $NEW_PROJECT_NAME with secrets provider $AZURE_KEY_VAULT_NAME ${NC}"
	    pulumi new $PROJ_LANG --dir $PWD/$NEW_PROJECT_NAME --secrets-provider="azurekeyvault://$AZURE_KEY_VAULT_NAME.vault.azure.net/keys/pulumi-key"
            ;;
        "Deploy existing project")
	    echo "${Green}Enter folder of existing project: \\ne.g ${NC} $PWD/<folder name> ${NC}"
	    read PROJECT_TO_DEPLOY
	    azGetSA
	    azLogin
	    cd $PWD/$PROJECT_TO_DEPLOY && pulumi up 
            ;;
        "Destroy existing project")
	    echo "${Green}Enter name of project to ${Red}destroy${Green}:${NC}"
	    read PROJECT_TO_DESTROY
	    echo "${Green}Enter name of stack to ${Red}destroy${Green}:${NC}"
	    read STACK_TO_DESTROY
	    azGetSA
	    azLogin
	    cd $PWD/$PROJECT_TO_DESTROY && pulumi destroy && pulumi stack rm $STACK_TO_DESTORY
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
