@description('Creates a virtual network with two subnets.')
param location string

var vnetName = 'myVNet'
var subnetPrefix = '10.0.0.0/16'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        cidrHost(subnetPrefix, 16)
      ]
    }
    subnets: [
      for i in range(1, 3): {
        name: 'Subnet${i}'
        properties: {
          addressPrefix: cidrSubnet(subnetPrefix, 24, i)
        }
      }
    ]
  }
}

output subnetRange array = [for i in range(1, 3): cidrSubnet(subnetPrefix, 24, i)]

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
