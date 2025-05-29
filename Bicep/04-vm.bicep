@description('Creates a virtual network with two subnets.')
param location string

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
