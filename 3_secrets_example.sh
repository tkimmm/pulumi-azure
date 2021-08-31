#!/bin/bash

# Example of encrypting project secrets using key in existing key vault

echo "\n0) Configure project secrets "
read VAR 

if [[ $VAR -eq 0 ]]
then 
	pulumi login --cloud-url azblob://$CONTAINER_NAME
	# Examples of adding secrets to project
	echo "Updating config values..."
	cd $PWD/$PROJECT_NAME
	pulumi config set --secret STORAGE-ACCESS-KEY $AZURE_STORAGE_KEY

elif [[ $VAR -eq 1 ]]
then

	echo "Placeholder..."
fi
