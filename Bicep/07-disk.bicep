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
      dataDisks: [
        { name: 'datadisk0', createOption: 'Empty', lun: 0, diskSizeGB: 16 }
      ]
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

resource datadisk 'Microsoft.Compute/disks@2022-07-02' = {
  name: 'datadisk1'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    diskSizeGB: 32
    creationData: {
      createOption: 'Empty'
    }
  }
}
