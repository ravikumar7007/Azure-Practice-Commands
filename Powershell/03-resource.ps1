$resourceGroupName = "app-rg"
$location = "East US"
$tag = @{ CreatedBy = "PowerShell" }
$networkName = "app-vnet"
$subnetName = "app-subnet"
$nicName = "app-nic"
$publicIpName = "app-public-ip"
$nsgName = "app-nsg"

$virtualNetwork = Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $networkName

$subnet = Get-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $virtualNetwork
#create the network interface card
New-AzNetworkInterface -Name $nicName `
  -ResourceGroupName $resourceGroupName `
  -SubnetId $subnet.Id `
  -IpConfigurationName "ipconfig" `
  -Location $location `
  -Tag $tag 

# Create a public IP address for the NIC
New-AzPublicIpAddress -Name $publicIpName `
  -ResourceGroupName $resourceGroupName `
  -Location $location `
  -AllocationMethod Static `
  -Tag $tag   

# Create a Network Security Group
$nsgRule1 = New-AzNetworkSecurityRuleConfig -Name "Allow-RDP" -Protocol Tcp `
  -Description "Allow RDP" -SourcePortRange * -DestinationPortRange 3389 `
  -SourceAddressPrefix * -DestinationAddressPrefix 10.0.0.0/24 `
  -Access Allow -Priority 120 -Direction Inbound
$nsgRule2 = New-AzNetworkSecurityRuleConfig -Name "Allow-HTTP" -Protocol Tcp `
  -Description "Allow HTTP" -SourcePortRange * -DestinationPortRange 80 `
  -SourceAddressPrefix * -DestinationAddressPrefix 10.0.0.0/24 `
  -Access Allow -Priority 130 -Direction Inbound

New-AzNetworkSecurityGroup -Name $nsgName `
  -ResourceGroupName $resourceGroupName `
  -Location $location `
  -Tag $tag `
  -SecurityRules $nsgRule1, $nsgRule2
