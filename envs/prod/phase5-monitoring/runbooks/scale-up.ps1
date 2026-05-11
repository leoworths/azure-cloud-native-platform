param(
    [string]$ResourceGroup = "platform-rg",
    [string]$ClusterName = "platform-aks",
    [string]$NodePoolName = "user"
)

Write-Output "Login with Managed Identity"
Connect-AzAccount -Identity | Out-Null

Write-Output "Scaling UP AKS node pool..."

az aks nodepool scale `
  --resource-group $ResourceGroup `
  --cluster-name $ClusterName `
  --name $NodePoolName `
  --node-count 2
  