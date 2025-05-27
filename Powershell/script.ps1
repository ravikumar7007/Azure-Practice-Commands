#Connect to Azure account
Connect-AzAccount

# Define the resource group and location
$resourceGroupName = "app-rg"
$location = "East US"
$tag = "CreatedBy=PowerShell"
$networkName = "app-vnet"
$addressPrefix = "10.0.0.0/16"

# Create the resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location -Tag $tag

# Create the virtual network
New-AzVirtualNetwork -ResourceGroupName $resourceGroupName `
  -Location $location -Name $networkName -AddressPrefix $addressPrefix `
  -Tag $tag

# Get Details of the virtual network
Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $networkName