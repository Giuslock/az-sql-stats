$ts = Get-Date

# File di output
$td = Get-Date -Format "yyyy.MM.dd_HH.mm"
$sqlServerFile = ".\SQLServer_Admin_List_$td.csv"
$subscriptionList = Get-AzSubscription

foreach ($subscription in $subscriptionList) {
    Write-Host "Controllando: $($subscription.name)"
    Set-AzContext $subscription.subscriptionId | Out-Null
    $rg = Get-AzResourceGroup
    $rgCount = $rg.Count
    $index = 1

    foreach ($resourcegroup in $rg) {
        
        Write-Host "RG $($index) di $($rgCount)"
        $SQLServers = Get-AzSqlServer -ResourceGroup $resourcegroup.ResourceGroupName
        $index++
        Write-Host "SQL Server presenti nel Resource group $($resourcegroup.ResourceGroupName): $($SQLServers.Count)"	
    
        if ($SQLServers.Count -eq 0) {
            continue
        }
        
    
        foreach ($sqlServer in $SQLServers) {
            $firewallRules = Get-AzSqlServerFirewallRule -ResourceGroupName $resourceGroup.ResourceGroupName -ServerName $sqlServer.ServerName
            $publicNetworkAccess = $false

            foreach ($rule in $firewallRules) {
                if ($rule -eq $null) {
                    $publicNetworkAccess = $false
                    break
                }
                else {
                    $publicNetworkAccess = $true
                }
            }
    
            if ($publicNetworkAccess) {
                Write-Host "Opzione 'Public network access' disabilitata"
            }
            else {
                Write-Host "Opzione 'Public network access' abilitata"
            }


            $sqlServer | Add-Member -MemberType NoteProperty -Name 'publicNetworkAccess' -Value $publicNetworkAccess -Force
            $sqlServer  | export-csv -Path $sqlServerFile  -NoTypeInformation -Append  
        }

        
    }
}

Write-host "Inizio processo: $ts" 
$ts = Get-Date
Write-host "Fine processo:   $ts" 