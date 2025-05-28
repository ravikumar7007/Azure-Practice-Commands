resource mystorageacc3739898842 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: 'mystorageacc3739898842'
  tags: {
    displayName: 'mystorageacc3739898842'
  }
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
