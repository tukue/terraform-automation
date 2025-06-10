# PowerShell script to run GitHub Action workflow locally
# Check if act is installed
if (-not (Get-Command act -ErrorAction SilentlyContinue)) {
    Write-Host "Installing act..."
    # For Windows, download the latest release
    $url = "https://github.com/nektos/act/releases/latest/download/act_Windows_x86_64.zip"
    $output = "$env:TEMP\act.zip"
    Invoke-WebRequest -Uri $url -OutFile $output
    Expand-Archive -Path $output -DestinationPath "$env:USERPROFILE\act" -Force
    $env:PATH += ";$env:USERPROFILE\act"
    Write-Host "act installed to $env:USERPROFILE\act"
}

# Run the terraform-scan workflow
Write-Host "Running terraform-scan workflow locally..."
act -j security-scan -W .github/workflows/terraform-scan.yml