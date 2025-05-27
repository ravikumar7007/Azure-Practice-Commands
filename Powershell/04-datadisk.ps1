$resourceGroupName = "app-rg"
# $location = "East US"
$tag = @{ CreatedBy = "PowerShell" }
$vmName = "app-vm"
$diskName = "app-datadisk"

$vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName
$vm | New-AzVMDataDisk -Name $diskName -DiskSizeInGB 16 `
  -CreateOption Empty -Lun 0  

Update-AzVM -ResourceGroupName $resourceGroupName -VM $vm -Tag $tag