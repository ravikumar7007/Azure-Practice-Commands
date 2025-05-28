param location string = resourceGroup().location
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'name'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        cidrHost('10.0.0.0', 16)
      ]
    }
    subnets: [
      for i in range(1, 3): {
        name: 'Subnet${i}'
        properties: {
          addressPrefix: cidrSubnet('10.0.0.0', 24, i)
        }
      }
    ]
  }
}
