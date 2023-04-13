$ts = Get-Date

# File di output
$td = Get-Date -Format "yyyy.MM.dd_HH.mm"
$sqlServerFile = ".\SQLServer_Admin_List_$td.csv"
$subscriptionList = Get-AzSubscription

foreach ($subscription in $subscriptionList) {
    Write-Host "Sub: $($subscription.name)" -ForegroundColor Yellow
    Set-AzContext $subscription.subscriptionId | Out-Null
    $rg = Get-AzResourceGroup
    $rgCount = $rg.Count
    $index = 1

    foreach ($resourcegroup in $rg) {
        
        Write-Host "RG: $($index) / $($rgCount)" -ForegroundColor Blue
        $SQLServers = Get-AzSqlServer -ResourceGroup $resourcegroup.ResourceGroupName
        $index++
        Write-Host "SQL Server in $($resourcegroup.ResourceGroupName): $($SQLServers.Count)" -ForegroundColor Blue	
    
        if ($SQLServers.Count -eq 0) {
            continue
        }
        
    
        foreach ($sqlServer in $SQLServers) {
            $firewallRules = Get-AzSqlServerFirewallRule -ResourceGroupName $resourceGroup.ResourceGroupName -ServerName $sqlServer.ServerName
            $publicNetworkAccess = $false

            foreach ($rule in $firewallRules) {
                if ($rule.FirewallRuleName -eq "AllowAllWindowsAzureIps") {
                    $publicNetworkAccess = $true
                    break
                }
            }
    
            if ($publicNetworkAccess) {
                Write-Host "Allow azure services su $($sqlServer.ServerName) abilitata" -ForegroundColor Red
            }
            else {
                Write-Host "Allow azure services su $($sqlServer.ServerName) disabilitata" -ForegroundColor Green
            }

            $sqlServer | Add-Member -MemberType NoteProperty -Name 'SubscriptionName' -Value $subscription.Name -Force
            $sqlServer | Add-Member -MemberType NoteProperty -Name 'AllowAzureServices' -Value $publicNetworkAccess -Force
            $sqlServer  | export-csv -Path $sqlServerFile  -NoTypeInformation -Append  
        }

        
    }
}

Write-host "Inizio processo: $ts" 
$ts = Get-Date
Write-host "Fine processo:   $ts" 
