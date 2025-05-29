param location string = resourceGroup().location

@secure()
param vmpassword string

param networkInterface object

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'mystorageaccount1234'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

resource windowsVM 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: 'app-vm'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s_v3'
    }
    osProfile: {
      computerName: 'app-vm'
      adminUsername: 'adminUser'
      adminPassword: vmpassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-Datacenter'
        version: 'latest'
      }
      osDisk: {
        name: 'osdisk1'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: '${storageaccount.id}.primaryEndpoints.blob'
      }
    }
  }
}
