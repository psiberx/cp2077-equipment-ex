param ($StageDir, $ProjectName, $Version)

$ScriptsDir = "${StageDir}/r6/scripts/${ProjectName}"
$GlobalScope = "${ProjectName}.Global"
$SettingsScope = "${ProjectName}.Settings"
$SettingsFile = "Settings.reds"

$Utf8 = [System.Text.UTF8Encoding]::new($false)
$SourceFiles = Get-ChildItem -Path "scripts" -Filter *.reds -Recurse
$Bundles = @{}

foreach ($ScriptFile in $SourceFiles) {
    $Content = [System.IO.File]::ReadAllLines($ScriptFile.FullName, $Utf8) | ForEach-Object { $_.TrimStart([char]0xFEFF) }
    $Module = ($Content | Select-String -Pattern "^module\s+(.+)" -List | %{$_.matches.groups[1].Value})
    $Scope = $Module ?? $GlobalScope

    if ($ScriptFile.Name -eq $SettingsFile) {
        $Scope = $SettingsScope
        $Imports = @()
        $Source = $Content | Out-String
    }
    else {
        $Imports = ($Content | Select-String -Pattern "^import\s+(.+)" -List | %{$_.matches.groups[1].Value})
        $Source = ($Content | Select-String -Pattern "^\s*(//|module\s|import\s)" -NotMatch) | Out-String
    }

    if ($Bundles[$Scope] -eq $null) {
        $Bundles[$Scope] = @{
            Scope = $Scope
            Module = $Module
            Imports = @{}
            Sources = [System.Collections.ArrayList]@()
        }
    }

    $Bundle = $Bundles[$Scope]
    $Bundle.Sources.Add($Source.Trim()) > $null

    if ($Imports -ne $null) {
        foreach ($Import in $Imports) {
            $Bundle.Imports[$Import] = 1
        }
    }
}

New-Item -ItemType directory -Force -Path ${ScriptsDir} | Out-Null
Copy-Item -Path "LICENSE" -Destination ${ScriptsDir}

foreach ($Bundle in $Bundles.Values) {
    $BundleFile = "${ScriptsDir}/$($Bundle.Scope).reds"
    $Lines = [System.Collections.Generic.List[string]]::new()
    $Lines.Add("// ${ProjectName} ${Version}")

    if ($Bundle.Module -and ($Bundle.Scope -ne $SettingsScope)) {
        $Lines.Add("module $($Bundle.Module)")
    }

    foreach ($Import in $Bundle.Imports.Keys) {
        $Lines.Add("import ${Import}")
    }

    foreach ($Source in $Bundle.Sources) {
        if ($Source) {
            $Lines.Add("")
            $Lines.Add($Source)
        }
    }

    [System.IO.File]::WriteAllText($BundleFile, ($Lines -join "`r`n") + "`r`n", $Utf8)
}
