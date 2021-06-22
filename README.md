# Pulumi Boilerplate

#### Rationale
This is a boilerplate project for the [Pulumi](https://pulumi.com) framework. This project uses pulumi in conjunction with Azure Storage for state persistence.

![Diagram](./docs/diagram.png)


## Required Tooling 

UNIX/Mac

- [Azure CLI](https://docs.microsoft.com/en-gb/cli/azure/install-azure-cli)
- [Jq](https://formulae.brew.sh/formula/jq)
- [Pulumi](https://formulae.brew.sh/formula/pulumi)


## Running Instructions

- Login through Azure CLI

- Update env vars in 1_init_pulumi.sh
- **Note** Please update default values to globally unique names i.e Keyvault etc.

![Diagram](./docs/env.png)

- Open terminal and run 

```
sh 1_init_pulumi.sh
```

It is recommended to follow the menu options chronologically for a new project.

## Contributing

Currently there are no pipelines running off this project, please follow feature flagging and open a PR if you require changes to this project.

e.g

```
feature/add-web-app
bugfix/remove-trailing-char
```

## TODO
- Error handling to prevent overwriting existing key
- Add azure-pipelines.yml and running instructions
- Add Docker version and test for x86 Windows

