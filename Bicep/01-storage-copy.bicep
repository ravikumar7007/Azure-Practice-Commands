param location string = resourceGroup().location
resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = [
  for i in range(0, 3): {
    name: 'mystorageaccount1234${i}'
    location: location
    kind: 'StorageV2'
    sku: {
      name: 'Standard_LRS'
    }
  }
]
