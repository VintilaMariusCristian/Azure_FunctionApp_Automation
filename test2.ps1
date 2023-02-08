$pis= az functionapp identity show --name msdocs-serverless-powershell-function-nuker  --resource-group vintila-function --query "principalId"
$pis
az role assignment create --assignee $pis --role "Contributor" --subscription "dbe857d8-f7ea-4c79-bb59-b4e5bc080426"