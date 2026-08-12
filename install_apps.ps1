Write-Host "A iniciar a verificação, instalação e atualização das aplicações..." -ForegroundColor Cyan

# Lista de aplicações a instalar via Winget
$wingetPackages = @(
    "Oracle.VirtualBox",
    "Mozilla.Firefox",
    "Microsoft.VisualStudioCode",
    "Microsoft.VisualStudio.Community",
    "Discord.Discord",
    "Valve.Steam"
)

# Ciclo de instalação via Winget
foreach ($pkg in $wingetPackages) {
    Write-Host "----------------------------------------"
    Write-Host "A verificar: $pkg..." -ForegroundColor Yellow
    
    $null = winget list --id $pkg --exact --accept-source-agreements 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "-> $pkg já está instalado. A procurar e aplicar atualizações..." -ForegroundColor Blue
        winget.exe upgrade --id $pkg --exact --accept-package-agreements --accept-source-agreements --silent
        Write-Host "-> Verificação de atualização para $pkg concluída!" -ForegroundColor Green
    } else {
        Write-Host "-> $pkg não foi encontrado. A instalar a versão mais recente a partir da internet..." -ForegroundColor Magenta
        winget.exe install --id $pkg --exact --accept-package-agreements --accept-source-agreements --silent
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "-> Sucesso: $pkg foi instalado com sucesso!" -ForegroundColor Green
        } else {
            Write-Host "-> Erro: Falha ao instalar $pkg. Verifica se o processo foi cancelado." -ForegroundColor Red
        }
    }
}

Write-Host "----------------------------------------"
Write-Host "Todas as operações concluídas!" -ForegroundColor Cyan