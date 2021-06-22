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
	pulumi config set --secret infra/armClientId $(echo $(pass infra/armClientId))
	pulumi config set --secret infra/armClientSecret $(echo $(pass infra/armClientSecret))
	pulumi config set --secret infra/armSubscriptionId $(echo $(pass infra/armSubscriptionId))
	pulumi config set --secret infra/armTenantId $(echo $(pass infra/armTenantId))
	pulumi config set --secret infra/docker/artifactoryPassword $(echo $(pass infra/docker/artifactoryPassword))
	pulumi config set --secret infra/docker/artifactoryUsername $(echo $(pass infra/docker/artifactoryUsername))
	pulumi config set --secret dev/dev1AppId $(echo $(pass dev/dev1AppId))
	pulumi config set --secret dev/dev1AppSecret $(echo $(pass dev/dev1AppSecret))
	pulumi config set --secret dev/dev2AppId $(echo $(pass dev/dev2AppId))

	pulumi config set --secret tcube/VUE_APP_DIRECTLINE_TOKEN $(echo $(pass tcube/VUE_APP_DIRECTLINE_TOKEN))
	pulumi config set --secret tcube/VUE_APP_DIRECTLINE_TOKEN_OLD $(echo $(pass tcube/VUE_APP_DIRECTLINE_TOKEN_OLD))
	pulumi config set --secret tcube/VUE_APP_PREPROCESSING_URL $(echo $(pass tcube/VUE_APP_PREPROCESSING_URL))
	pulumi config set --secret tcube/VUE_APP_SPEECH_ENDPOINT_ID_DE $(echo $(pass tcube/VUE_APP_SPEECH_ENDPOINT_ID_DE))
	pulumi config set --secret tcube/VUE_APP_SPEECH_ENDPOINT_ID_EN $(echo $(pass tcube/VUE_APP_SPEECH_ENDPOINT_ID_EN))
	pulumi config set --secret tcube/VUE_APP_SPEECH_SUBSCRIPTION_KEY $(echo $(pass tcube/VUE_APP_SPEECH_SUBSCRIPTION_KEY))
	pulumi config set --secret tcube/VUE_APP_SPEECH_SERVICE_REGION $(echo $(pass tcube/VUE_APP_SPEECH_SERVICE_REGION))
	pulumi config set --secret tcube/sql_username $(echo $(pass tcube/sql_username))
	pulumi config set --secret tcube/sql_password $(echo $(pass tcube/sql_password))
	pulumi config set --secret tcube/sql_connection $(echo $(pass tcube/sql_connection))
	pulumi config set --secret tcube/testsecret $(echo $(pass tcube/testsecret))

elif [[ $VAR -eq 1 ]]
then

	echo "Placeholder..."
fi
