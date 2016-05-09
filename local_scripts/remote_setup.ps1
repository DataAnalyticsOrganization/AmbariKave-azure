param(
	$resource_group = "Kave-Test-Riccardo-bis",
	$user = "KaveAdmin",
	$remote_scripts_dir = "kave_scripts",
	$blueprints_dir = "kave_blueprints",
	$keypath = "C:\Users\rvincelli\.ssh\key.rsa"
)

#the ambari node is publicly accessible - this should hold no further the installation duration
$ip = azure vm show $resource_group ambari | grep "Public IP address" | awk -F ":" '{print $3}'

scp -i ${keypath} -r "${remote_scripts_dir}" $user@${ip}:~
scp -i ${keypath} -r "${blueprints_dir}" $user@${ip}:~

echo You can now start the installation manually on every node
