$rgName = 'rg-community-build-conapp'
$location = 'westeurope'
az group create -n $rgName -l $location
az deployment group create -g $rgName -f main.bicep 


# az containerapp revision show -n 'messageservice' -g 'rg-community-build-conapp' --revision messageservice--cjp66ow

# az containerapp env dapr-component list -g rg-community-build-conapp --name env-ozr2nmuwuplzu
# az containerapp env dapr-component show -g rg-community-build-conapp --name env-ozr2nmuwuplzu --dapr-component-name dapr-demo-state-store

### Failed to provision revision for container app 'client'. Error details: Operation expired.
# configuration: {
#   dapr: {
#     enabled: true
#     appId: 'clientdapr'
#     appProtocol: 'grpc'
#     appPort: 50001
#   }
# }


### Provision Status Failed
# configuration: {
#     ingress: {
#     external: false
#     targetPort: 50001
#     }
#     dapr: {
#     enabled: true
#     appId: 'clientdapr'
#     appProtocol: 'grpc'
#     appPort: 50001
#     }

### Provision Status Failed
# configuration: {
#     ingress: {
#     external: false
#     targetPort: 50001
#     }
#     }

## NO ingress, NO dapr => WORKING | NO ingress, NO dapr => NOT WORKING
## NO ingress, NO dapr => WORKING | YES ingress, YES dapr => NOT WORKING (PROVISIONING failed)
## NO ingress, YES dapr => NOT WOKRING, No revision
