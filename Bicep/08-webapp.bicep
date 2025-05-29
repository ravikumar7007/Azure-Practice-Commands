param location string = resourceGroup().location

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: 'app-plan-23433'
  location: location
  sku: {
    name: 'B1'
    capacity: 1
  }
  kind: 'Linux'
}

resource webApplication 'Microsoft.Web/sites@2021-01-15' = {
  name: 'webapp-23433'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'Java|21'
      alwaysOn: true
      javaVersion: '21'
    }
  }
  kind: 'app,linux'
}
