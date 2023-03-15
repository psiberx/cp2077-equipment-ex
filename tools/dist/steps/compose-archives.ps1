param ($StageDir, $ReleaseBin, $ProjectName)

$ArchiveDir = "${StageDir}/archive/pc/mod"

New-Item -ItemType directory -Force -Path ${ArchiveDir} | Out-Null
Copy-Item -Path "archive/packed/archive/pc/mod/*" -Destination ${ArchiveDir}
Copy-Item -Path "archive/source/resources/*" -Destination ${ArchiveDir}
