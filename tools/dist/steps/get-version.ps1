Select-String -Path "scripts/Facade.reds" -Pattern """(\d+\.\d+\.\d+)""" -List | %{"$($_.Matches.Groups[1])"} | Write-Output
