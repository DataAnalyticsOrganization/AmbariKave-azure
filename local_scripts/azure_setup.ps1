param(
	$template = "..\azure_template\KAVEAzure.azure.json",
	$parameters = "..\azure_template\KAVEAzure.azure.parameters.json",
	$region = "westeurope",
	$resource_group = "Kave-Test",
	$alias =  "KaveTest",
	$gateway = "gate"
)

azure config mode arm 

azure login

azure group create -n $resource_group -l $region

azure group deployment create -f $template -e $parameters -g $resource_group -n $alias

echo ---

echo "Gateway node info:"

azure vm show $resource_group $gate

echo ---

azure login

echo ---

echo "You can login onto the gateway using ssh; check the user in the JSON parameters file (eg KAVEAdminUserName/KAVEAdminPassword), that will log you in the rest of the boxes too"
