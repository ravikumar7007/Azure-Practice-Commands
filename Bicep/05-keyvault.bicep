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

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: 'name'
  scope: resourceGroup('6912d7a0-bc28-459a-9407-33bbba641c07', 'app-grp')
}

module vm '05-module.bicep' = {
  name: 'vmDeployment'
  params: {
    networkInterface: networkInterface
    vmpassword: keyVault.getSecret('vmpassword')
    location: location
  }
}
