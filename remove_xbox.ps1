Write-Host "A INICIAR REMOÇÃO TOTAL DO ECOSSISTEMA XBOX E GAMING..." -ForegroundColor Cyan

Write-Host "----------------------------------------"
Write-Host "Passo 1: Desinstalar todas as Aplicações e Frameworks..." -ForegroundColor Yellow

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
    Write-Host "A remover: $app" -ForegroundColor DarkGray
    Get-AppxPackage -AllUsers $app | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
}
Write-Host "-> Aplicações removidas!" -ForegroundColor Green

Write-Host "----------------------------------------"
Write-Host "Passo 2: Parar e Desativar TODOS os Serviços Xbox..." -ForegroundColor Yellow

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
        Write-Host "A desativar serviço: $service" -ForegroundColor DarkGray
        Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
        Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
    }
}
Write-Host "-> Serviços desativados!" -ForegroundColor Green

Write-Host "----------------------------------------"
Write-Host "Passo 3: Desativar Funcionalidades no Registo (Game Bar / DVR)..." -ForegroundColor Yellow

try {
    Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AutoGameModeEnabled" -Value 0 -ErrorAction SilentlyContinue
    Write-Host "-> Registos desativados!" -ForegroundColor Green
} catch {
    Write-Host "-> Erro ao alterar o Registo." -ForegroundColor Red
}

Write-Host "----------------------------------------"
Write-Host "Passo 4: Remover Tarefas Agendadas da Xbox..." -ForegroundColor Yellow

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
Write-Host "-> Tarefas agendadas desativadas!" -ForegroundColor Green

Write-Host "----------------------------------------"
Write-Host "REMOÇÃO TOTAL CONCLUÍDA! O teu PC está agora livre de serviços Xbox." -ForegroundColor Cyan