# Azure Pipelines

It is recommended that the project is initialised locally in order to provision the intial storage account, keyvault and project with keyvault secrets provider

1) Install [Pulumi task provider plugin](https://marketplace.visualstudio.com/items?itemName=pulumi.build-and-release-task)

2) Create a new Service Connection in project settings menu

Example values used
- Azure Resource Manager
- Service Principal (Automatic) unless using predefinied SPN
- If using automatic ensure the necessary rights are granted to the pipeline application
- Select Subscription and Resource Group scopes
- This example uses "WestEuropePipelineConnection" as the service connection name, if a different name is specified update the azure-pipelines.yaml ServiceConnection name variable.

3) Create pipeline from existing file azure-pipelines.yml in root directory

4) Run pipeline and replace folder name with name of Pulumi project folder created 

# Usage

Triggers are provided based of source head feature, dev and master

## Release strategy
- Release branches off master
- Hotfixes on release branch 
- Cherry pick into master
- Abandon release 

## Workflow process

- Developer branches off target environment using "feature/<feature name>" 
- Developer commits/pushes to this branch 
- CI/CD process begins and previews infrastructure mutation
- Developer opens a pull request merging feature branch into target environment (dev in this case)
- Infrastructure engineer reviews mutation to deployed state
- Infrastructure engineer approves pull request
- Target infrastructure is updated