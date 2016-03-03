# Ambarikave-azure
In this repo we contain publishable azure deployments of the AmbariKave. Currently this isn't open-sourced yet and under heavy development.

The goal is to make the environment provisionable via a provision button. This will only work with these buttons: 

[![deploy](img/deploybutton.png)]()
[![deploy](img/visualizebutton.png)]()

Currently that won't work since the installation of the associated blueprint isn't automated. Here is the reference HTML we have to provide:

```html
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-quickstart-templates%2Fmaster%2F101-application-gateway-create%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-quickstart-templates%2Fmaster%2F101-application-gateway-create%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>
``` 

## Getting the azure-cli 
There are many ways to get the azure-cli. Just google it.. Options I've seen: 

 - windows powershell
 - windows command prompt
 - linux apt installation 

However docker is a great way to go as well. Install docker and go for: 

```bash
sudo docker run -it microsoft/azure-cli
```

If you don't use the docker image be sure to set the azure-cli mode to __arm__. This will make the cli communicate with the new API (which supports the templates). You can do this by doing: 

```bash
azure config mode arm 
```

## Deploying a template

```bash 
azure login 

azure group create -n Kave-Test -l "westeurope"

azure group deployment create -f <PathToTemplate> -e <PathToProperties> -g Kave-Test -n KaveTestDeployment
```




