Select-String -Path "scripts/EquipmentEx.reds" -Pattern """(\d+\.\d+\.\d+)""" -List | %{"$($_.Matches.Groups[1])"} | Write-Output
