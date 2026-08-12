Write-Host "STARTING TOTAL REMOVAL OF THE XBOX AND GAMING ECOSYSTEM..." -ForegroundColor Cyan

Write-Host "----------------------------------------"
Write-Host "Step 1: Uninstall all Applications and Frameworks..." -ForegroundColor Yellow

$allXboxApps = @(
    "*Microsoft.XboxApp*",
    "*Microsoft.XboxGamingOverlay*",
    "*Microsoft.XboxIdentityProvider*",
    "*Microsoft.XboxSpeechToTextOverlay*",
    "*Microsoft.GamingServices*",
    "*Microsoft.Xbox.TCUI*",
    "*Microsoft.XboxGameCallableUI*"
)

foreach ($app in $allXboxApps) {
    Write-Host "Removing: $app" -ForegroundColor DarkGray
    Get-AppxPackage -AllUsers $app | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
}
Write-Host "-> Applications removed!" -ForegroundColor Green

Write-Host "----------------------------------------"
Write-Host "Step 2: Stop and Disable ALL Xbox Services..." -ForegroundColor Yellow

$allXboxServices = @(
    "XblAuthManager",      
    "XblGameSave",         
    "XboxNetApiSvc",       
    "XboxGipSvc",          
    "GamingServices",      
    "GamingServicesNet",   
    "GameInputSvc"         
)

foreach ($service in $allXboxServices) {
    if (Get-Service -Name $service -ErrorAction SilentlyContinue) {
        Write-Host "Disabling service: $service" -ForegroundColor DarkGray
        Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
        Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
    }
}
Write-Host "-> Services disabled!" -ForegroundColor Green

Write-Host "----------------------------------------"
Write-Host "Step 3: Disable Features in the Registry (Game Bar / DVR)..." -ForegroundColor Yellow

try {
    Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AutoGameModeEnabled" -Value 0 -ErrorAction SilentlyContinue
    Write-Host "-> Registry entries disabled!" -ForegroundColor Green
} catch {
    Write-Host "-> Error altering the Registry." -ForegroundColor Red
}

Write-Host "----------------------------------------"
Write-Host "Step 4: Remove Xbox Scheduled Tasks..." -ForegroundColor Yellow

$xboxTasks = @(
    "\Microsoft\XblGameSave\XblGameSaveTask",
    "\Microsoft\XblGameSave\XblGameSaveTaskLogon"
)

foreach ($task in $xboxTasks) {
    $taskName = ($task -split '\\')[-1]
    if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
        Disable-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue | Out-Null
    }
}
Write-Host "-> Scheduled tasks disabled!" -ForegroundColor Green

Write-Host "----------------------------------------"
Write-Host "TOTAL REMOVAL COMPLETED! Your PC is now free of Xbox services." -ForegroundColor Cyan