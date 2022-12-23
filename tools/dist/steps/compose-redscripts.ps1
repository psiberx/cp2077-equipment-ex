param ($StageDir, $ProjectName)

$ScriptsDir = "${StageDir}/r6/scripts/${ProjectName}"

New-Item -ItemType directory -Force -Path ${ScriptsDir} | Out-Null
Copy-Item -Path "scripts/*" -Destination ${ScriptsDir} -Recurse
Copy-Item -Path "LICENSE" -Destination ${ScriptsDir}
