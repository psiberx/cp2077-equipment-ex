param ($StageDir, $ReleaseBin, $ProjectName)

$ArchiveDir = "${StageDir}/archive/pc/mod"

New-Item -ItemType directory -Force -Path ${ArchiveDir} | Out-Null
Copy-Item -Path "archive/packed/archive/pc/mod/*" -Destination ${ArchiveDir}
