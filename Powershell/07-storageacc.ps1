$resourceGroupName = "app-rg"
$location = "East US"
$tag = @{ CreatedBy = "PowerShell" }
$storageAccountName = "appstorageacct63734849249" # Must be globally unique


# Create a storage account

New-AzStorageAccount -ResourceGroupName $resourceGroupName `
  -Name $storageAccountName `
  -Location $location `
  -SkuName Standard_LRS `
  -Kind StorageV2 `
  -AccessTier Hot `
  -Tag $tag