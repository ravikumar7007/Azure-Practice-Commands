$resourceGroupName = "app-rg"
$location = "East US"
$tag = @{ CreatedBy = "PowerShell" }
$aspName = "app-asp"
$webappName = "app-webapp-123456" # Must be globally unique

# Create a Az Webapp App Service Plan

New-AzAppServicePlan -Name $aspName `
  -ResourceGroupName $resourceGroupName `
  -Location $location `
  -Tier Standard `
  -Tag $tag `
  -Linux

# Create a Az Webapp

$webapp = New-AzWebApp -ResourceGroupName $resourceGroupName `
  -Name $webappName `
  -Location $location `
  -AppServicePlan $aspName `
  -Tag $tag
