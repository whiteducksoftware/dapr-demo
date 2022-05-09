$rgName = 'rg-community-build-conapp'
$location = 'westeurope'
az group create -n $rgName -l $location
az deployment group create -g $rgName -f main.bicep 


# \
#   -p \
#     minReplicas=0 \
#     nodeImage='ghcr.io/jeffhollan/container-apps-store-api-microservice/node-service:main' \
#     nodePort=3000 \
#     pythonImage='ghcr.io/jeffhollan/container-apps-store-api-microservice/python-service:main' \
#     pythonPort=5000 \
#     goImage='ghcr.io/jeffhollan/container-apps-store-api-microservice/go-service:main' \
#     goPort=8050 \
#     isPrivateRegistry=false \
#     deployApim=true \
#     containerRegistry=ghcr.io