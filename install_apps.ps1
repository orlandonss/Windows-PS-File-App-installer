Write-Host "Starting the verification, installation, and update of applications..." -ForegroundColor Cyan

# List of applications to install via Winget
$wingetPackages = @(
    "Oracle.VirtualBox",
    "Mozilla.Firefox",
    "Microsoft.VisualStudioCode",
    "Microsoft.VisualStudio.Community",
    "Discord.Discord",
    "Valve.Steam",
    "Git.Git"
)

# Installation loop via Winget
foreach ($pkg in $wingetPackages) {
    Write-Host "----------------------------------------"
    Write-Host "Checking: $pkg..." -ForegroundColor Yellow
    
    $null = winget list --id $pkg --exact --accept-source-agreements 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "-> $pkg is already installed. Checking and applying updates..." -ForegroundColor Blue
        winget.exe upgrade --id $pkg --exact --accept-package-agreements --accept-source-agreements --silent
        Write-Host "-> Update check for $pkg completed!" -ForegroundColor Green
    } else {
        Write-Host "-> $pkg was not found. Installing the latest version from the internet..." -ForegroundColor Magenta
        winget.exe install --id $pkg --exact --accept-package-agreements --accept-source-agreements --silent
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "-> Success: $pkg was installed successfully!" -ForegroundColor Green
        } else {
            Write-Host "-> Error: Failed to install $pkg. Check if the process was canceled." -ForegroundColor Red
        }
    }
}

Write-Host "----------------------------------------"
Write-Host "All operations completed!" -ForegroundColor Cyan