@description('Location a virtual Machine.')
param location string

@secure()
@description('The password for the virtual machine administrator account.')
param vmpassword string

var vnetName = 'myVNet'
var vnetPrefix = '10.0.0.0/16'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        cidrHost(vnetPrefix, 16)
      ]
    }
    subnets: [
      {
        name: 'SubnetA'
        properties: {
          addressPrefix: cidrSubnet(vnetPrefix, 24, 0)
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }
    ]
  }
}

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: 'app-pip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Standard'
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: 'app-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'

          subnet: {
            id: '${virtualNetwork.id}/subnets/Subnet1'
          }
          publicIPAddress: { id: publicIPAddress.id }
        }
      }
    ]
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'app-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow-rdp'
        properties: {
          description: 'Allow RDP access'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'allow-http'
        properties: {
          description: 'Allow RDP access'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: cidrSubnet(vnetPrefix, 24, 0)
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
        }
      }
    ]
  }
}

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

resource windowsVMExtensions 'Microsoft.Compute/virtualMachines/extensions@2020-12-01' = {
  parent: windowsVM
  name: 'app-vm'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        'https://appstore4434343.blob.core.windows.net/scripts/setup1.ps1?sv=2022-11-02&ss=b&srt=sco&sp=rl&se=2023-07-12T13:17:32Z&st=2023-07-12T05:17:32Z&spr=https&sig=yu7gVQgUr97VxXNU7Qaq4hG%2BvJKHvlxEw69g0kC1Pxc%3D'
      ]
    }
    protectedSettings: {
      commandToExecute: 'powershell -ExecutionPolicy Bypass -file customScript.ps1'
    }
  }
}
