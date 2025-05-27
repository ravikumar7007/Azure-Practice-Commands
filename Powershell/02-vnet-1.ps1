# Define the Variables
$resourceGroupName = "app-rg"
$location = "East US"
$tag = @{ CreatedBy = "PowerShell" }
$networkName = "app-vnet"
$addressPrefix = "10.0.0.0/16"
$subnetName = "app-subnet"
$subnetAddressPrefix = "10.0.0.0/24"

# Create the subnet configuration
$subnet = New-AzVirtualNetworkSubnetConfig -Name $subnetName `
  -AddressPrefix $subnetAddressPrefix

# Create the Vnet and Subnet in single command
New-AzVirtualNetwork -Name $networkName `
  -ResourceGroupName $resourceGroupName `
  -Location $location `
  -AddressPrefix $addressPrefix `
  -Tag $tag `
  -Subnet $subnet