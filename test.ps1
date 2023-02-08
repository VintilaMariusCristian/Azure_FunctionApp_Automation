# Function app and storage account names must be unique.

# Variable block

$location="eastus"
$resourceGroup="vintila-function"
$tag="create-function-app-consumption-powershell"
$storage="msdocsaccount22vintila"
$functionApp="msdocs-serverless-powershell-function-nuker"
$skuStorage="Standard_LRS"
$functionsVersion="4"
$powershellVersion="7.2" #Allowed values: 3.7, 3.8, and 3.9

# Create a resource group
echo "Creating $resourceGroup in "$location"..."
az group create --name $resourceGroup --location "$location" --tags $tag

# Create an Azure storage account in the resource group.
echo "Creating $storage"
az storage account create --name $storage --location "$location" --resource-group $resourceGroup --sku $skuStorage

# Create a serverless powershell function app in the resource group.
echo "Creating $functionApp"
az functionapp create --name $functionApp --storage-account $storage --consumption-plan-location "$location" --resource-group $resourceGroup --assign-identity '[system]' --os-type Windows --runtime powershell --runtime-version $powershellVersion --functions-version $functionsVersion 

Start-Sleep -seconds 5

#install the necessary requiements for the "func" to operate accordingly
echo "Install necessary requirements"
#npm install -g azure-functions-core-tools@4 --unsafe-perm true


#necessary wait time - the custom domain of the function needs some time to be updated 
echo "Wait-time around 30 seconds for the API to get ready ..."
Start-Sleep -seconds 30


#publish the function to the functionapp 
echo "Publishing the function inside Function App"
func azure functionapp publish msdocs-serverless-powershell-function-nuker

Start-Sleep -seconds 5
#extract the principalID of the functionapp resource 
echo "Extracting the PrincipalId of the FunctionApp"
# $pis= az functionapp identity show --name msdocs-serverless-powershell-function-nuker  --resource-group vintila-function --query "principalId"

# $pis

# assign the contributor role to functionapp
echo "Allocating the contributor role to the Function App"
# az role assignment create --assignee $pis --role "Contributor" --subscription "dbe857d8-f7ea-4c79-bb59-b4e5bc080426"


