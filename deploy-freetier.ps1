<#
.SYNOPSIS
    Deployment script for Terraform GCP infrastructure.
.DESCRIPTION
    This script handles the deployment of infrastructure to different environments,
    including the free-tier environment, with security scanning and validation.
.PARAMETER Environment
    The environment to deploy to. Valid options: free-tier, dev, qa, test, prod.
.EXAMPLE
    .\deploy.ps1 -Environment free-tier
#>

param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("free-tier", "dev", "qa", "test", "prod")]
    [string]$Environment
)

# Set color scheme
$infoColor = "Cyan"
$successColor = "Green"
$warningColor = "Yellow"
$errorColor = "Red"

# Display header
Write-Host "=====================================================" -ForegroundColor $infoColor
Write-Host "  Terraform GCP Infrastructure Deployment" -ForegroundColor $infoColor
Write-Host "=====================================================" -ForegroundColor $infoColor
Write-Host "Environment: $Environment" -ForegroundColor $infoColor
Write-Host "Timestamp: $(Get-Date)" -ForegroundColor $infoColor
Write-Host "====================================================="

# Determine var file path based on environment
if ($Environment -eq "free-tier") {
    $varFile = "environments/free-tier.tfvars"
} else {
    $varFile = "environments/$Environment.tfvars"
}

# Check if var file exists
if (-not (Test-Path $varFile)) {
    Write-Host "Error: Variable file '$varFile' does not exist!" -ForegroundColor $errorColor
    Write-Host "Please create the variable file for the $Environment environment first." -ForegroundColor $errorColor
    exit 1
}

# Run security scan
Write-Host "`nStep 1: Running security scan..." -ForegroundColor $infoColor
try {
    & .\run-terrascan.cmd
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Security scan detected high severity issues!" -ForegroundColor $warningColor
        $proceed = Read-Host "Do you want to continue despite security issues? (y/n)"
        if ($proceed -ne "y") {
            Write-Host "Deployment cancelled." -ForegroundColor $errorColor
            exit 1
        }
        Write-Host "Proceeding despite security issues..." -ForegroundColor $warningColor
    } else {
        Write-Host "Security scan passed." -ForegroundColor $successColor
    }
} catch {
    Write-Host "Error running security scan: $_" -ForegroundColor $errorColor
    $proceed = Read-Host "Do you want to continue without security scanning? (y/n)"
    if ($proceed -ne "y") {
        Write-Host "Deployment cancelled." -ForegroundColor $errorColor
        exit 1
    }
}

# Initialize Terraform if not already done
if (-not (Test-Path ".terraform")) {
    Write-Host "`nStep 2: Initializing Terraform..." -ForegroundColor $infoColor
    terraform init
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Terraform initialization failed!" -ForegroundColor $errorColor
        exit 1
    }
} else {
    Write-Host "`nStep 2: Terraform already initialized." -ForegroundColor $successColor
}

# Special warnings for free-tier environment
if ($Environment -eq "free-tier") {
    Write-Host "`n⚠️ FREE TIER DEPLOYMENT NOTES:" -ForegroundColor $warningColor
    Write-Host "- Using f1-micro instance type to qualify for free tier" -ForegroundColor $warningColor
    Write-Host "- Using single instance to minimize costs" -ForegroundColor $warningColor
    Write-Host "- Database configured with minimal resources (db-f1-micro, 10GB storage)" -ForegroundColor $warningColor
    Write-Host "- Remember that some resources may still incur charges beyond free tier limits" -ForegroundColor $warningColor
    
    $confirmFreeTier = Read-Host "Confirm free tier deployment (y/n)"
    if ($confirmFreeTier -ne "y") {
        Write-Host "Deployment cancelled." -ForegroundColor $errorColor
        exit 1
    }
}

# Plan the deployment
Write-Host "`nStep 3: Planning deployment for $Environment environment..." -ForegroundColor $infoColor
terraform plan -var-file="$varFile" -out="${Environment}.tfplan"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Terraform plan failed!" -ForegroundColor $errorColor
    exit 1
}

# Ask for confirmation
$confirm = Read-Host "`nDo you want to apply this plan? (y/n)"
if ($confirm -eq "y") {
    # Apply the plan
    Write-Host "`nStep 4: Applying plan for $Environment environment..." -ForegroundColor $infoColor
    terraform apply "${Environment}.tfplan"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Terraform apply failed!" -ForegroundColor $errorColor
        exit 1
    }
    
    # Show outputs
    Write-Host "`nDeployment completed successfully!" -ForegroundColor $successColor
    Write-Host "`nOutputs:" -ForegroundColor $infoColor
    terraform output
    
    # Remove plan file
    Remove-Item "${Environment}.tfplan" -ErrorAction SilentlyContinue
    
    # Free tier specific notes
    if ($Environment -eq "free-tier") {
        Write-Host "`n✅ FREE TIER DEPLOYMENT COMPLETED" -ForegroundColor $successColor
        Write-Host "- Monitor your billing to ensure you stay within free tier limits" -ForegroundColor $infoColor
        Write-Host "- Check console at: https://console.cloud.google.com/billing/01D3D1-9D3155-6A30E3" -ForegroundColor $infoColor
    }
} else {
    Write-Host "Deployment cancelled." -ForegroundColor $errorColor
    # Remove plan file
    Remove-Item "${Environment}.tfplan" -ErrorAction SilentlyContinue
}