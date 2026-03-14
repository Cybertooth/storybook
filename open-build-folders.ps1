# PowerShell script to open build result folders in Windows Explorer

Write-Host "Opening Storybook build folders..." -ForegroundColor Cyan

$windowsPath = Join-Path $PSScriptRoot "android\build\windows\x64\runner\Release"
$androidPath = Join-Path $PSScriptRoot "android\build\app\outputs\flutter-apk"

if (Test-Path $windowsPath) {
    Write-Host "Opening Windows build folder: $windowsPath" -ForegroundColor Green
    explorer $windowsPath
} else {
    Write-Host "Windows build folder not found: $windowsPath" -ForegroundColor Yellow
}

if (Test-Path $androidPath) {
    Write-Host "Opening Android build folder: $androidPath" -ForegroundColor Green
    explorer $androidPath
} else {
    Write-Host "Android build folder not found: $androidPath" -ForegroundColor Yellow
}
