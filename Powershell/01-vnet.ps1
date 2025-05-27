# Connect to Azure account
Connect-AzAccount

# Define the Variables
$resourceGroupName = "app-rg"
$location = "East US"
$tag = @{ CreatedBy = "PowerShell" }
$networkName = "app-vnet"
$addressPrefix = "10.0.0.0/16"
$subnetName = "app-subnet"
$subnetAddressPrefix = "10.0.0.0/24"

# Create the resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location -Tag $tag

# Create the virtual network
New-AzVirtualNetwork -ResourceGroupName $resourceGroupName `
  -Location $location `
  -Name $networkName `
  -AddressPrefix $addressPrefix `
  -Tag $tag

# Get details of the virtual network
$virtualNetwork = Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $networkName
Write-Host "Virtual Network Object: $virtualNetwork"
Write-Host "Location: $($virtualNetwork.Location)"
Write-Host "Address Prefixes: $($virtualNetwork.AddressSpace.AddressPrefixes)"

# Create a subnet within the virtual network
New-AzVirtualNetworkSubnetConfig -Name $subnetName `
  -AddressPrefix $subnetAddressPrefix `
  -VirtualNetwork $virtualNetwork

$virtualNetwork | Set-AzVirtualNetwork