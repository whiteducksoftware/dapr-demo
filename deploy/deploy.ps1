$rgName = 'rg-community-build-conapp'
$location = 'westeurope'
az group create -n $rgName -l $location
az deployment group create -g $rgName -f main.bicep 


# az containerapp revision show -n 'messageservice' -g 'rg-community-build-conapp' --revision messageservice--cjp66ow

# az containerapp env dapr-component list -g rg-community-build-conapp --name env-ozr2nmuwuplzu
# az containerapp env dapr-component show -g rg-community-build-conapp --name env-ozr2nmuwuplzu --dapr-component-name dapr-demo-state-store
