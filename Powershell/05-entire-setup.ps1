# Define the Variables
$resourceGroupName = "app-rg"
$location = "East US"
$tag = @{ CreatedBy = "PowerShell" }
$networkName = "app-vnet"
$addressPrefix = "10.0.0.0/16"
$subnetName = "app-subnet"
$subnetAddressPrefix = "10.0.0.0/24"
$nicName = "app-nic"
$publicIpName = "app-public-ip"
$nsgName = "app-nsg"
$vmName = "appvm"
$vmSize = "Standard_DS2_v2"

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

# Create a public IP address for the NIC
$publicIP = New-AzPublicIpAddress -Name $publicIpName `
  -ResourceGroupName $resourceGroupName `
  -Location $location `
  -AllocationMethod Static `
  -Tag $tag  

$virtualNetwork = Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $networkName

$subnet = Get-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $virtualNetwork
# Create the network interface card
$networkInterface = New-AzNetworkInterface -Name $nicName `
  -ResourceGroupName $resourceGroupName `
  -SubnetId $subnet.Id `
  -IpConfigurationName "ipconfig" `
  -Location $location `
  -Tag $tag 

$ipconfig = Get-AzNetworkInterfaceIpConfig -NetworkInterface $networkInterface

Set-AzNetworkInterfaceIpConfig -PublicIpAddress $publicIP -Name $ipconfig.Name -NetworkInterface $networkInterface

Set-AzNetworkInterface -NetworkInterface $networkInterface

$nsgRule1 = New-AzNetworkSecurityRuleConfig -Name "Allow-RDP" -Protocol Tcp `
  -Description "Allow RDP" -SourcePortRange * -DestinationPortRange 3389 `
  -SourceAddressPrefix * -DestinationAddressPrefix 10.0.0.0/24 `
  -Access Allow -Priority 120 -Direction Inbound
$nsgRule2 = New-AzNetworkSecurityRuleConfig -Name "Allow-HTTP" -Protocol Tcp `
  -Description "Allow HTTP" -SourcePortRange * -DestinationPortRange 80 `
  -SourceAddressPrefix * -DestinationAddressPrefix 10.0.0.0/24 `
  -Access Allow -Priority 130 -Direction Inbound

$nsg = New-AzNetworkSecurityGroup -Name $nsgName `
  -ResourceGroupName $resourceGroupName `
  -Location $location `
  -Tag $tag `
  -SecurityRules $nsgRule1, $nsgRule2

Set-AzVirtualNetworkSubnetConfig -Name $subnetName `
  -VirtualNetwork $virtualNetwork `
  -NetworkSecurityGroup $nsg -AddressPrefix $subnetAddressPrefix

Set-AzVirtualNetwork -VirtualNetwork $virtualNetwork

$vmConfig = New-AzVMConfig -VMName $vmName -VMSize $vmSize
$Credentials = Get-Credential

# Set the operating system for the VM (Windows, with credentials)
Set-AzVMOperatingSystem -VM $vmConfig -Windows -ComputerName $vmName -Credential $Credentials

# Set the source image for the VM (Windows Server 2022 Datacenter)
Set-AzVMSourceImage -VM $vmConfig -PublisherName "MicrosoftWindowsServer" `
  -Offer "WindowsServer" -Skus "2022-Datacenter" -Version "latest"

# Attach the network interface to the VM configuration
$vm = Add-AzVMNetworkInterface -VM $vmConfig -Id $networkInterface.Id

# Create the VM in Azure with the specified configuration
New-AzVM -ResourceGroupName $resourceGroupName `
  -Location $location `
  -VM $vm

# Retrieve the VM object for further configuration
$vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName

# Add a new empty data disk to the VM (16 GB, LUN 0)
$vm | New-AzVMDataDisk -Name $diskName -DiskSizeInGB 16 `
  -CreateOption Empty -Lun 0  

# Update the VM in Azure to apply the new data disk and tags
Update-AzVM -ResourceGroupName $resourceGroupName -VM $vm -Tag $tag