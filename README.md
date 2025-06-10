# Advanced Terraform Project

This project demonstrates advanced Terraform practices for infrastructure deployment.

## Prerequisites

- Terraform v1.0.0+
- PowerShell Core (pwsh) for security scanning
- Terrascan for security scanning
- Act (optional, for running GitHub Actions locally)

## Local Development

### Security Scanning

You can run security scans locally using:

1. PowerShell script:
   ```
   pwsh ./scan-terraform.ps1
   ```

2. GitHub Actions locally (requires act):
   ```
   act -j security-scan -W .github/workflows/terraform-security.yml
   ```

3. Terrascan directly:
   ```
   terrascan scan -i terraform -d . -o human
   ```

### Deployment

To deploy to an environment:

```
./deploy.sh <environment>
```

Where `<environment>` is one of: qa, test, prod

## GitHub Actions

This project includes GitHub Actions workflows for:

- Terraform security scanning
- Infrastructure validation

## Project Structure

- `modules/` - Reusable Terraform modules
- `environments/` - Environment-specific variable files
- `.github/workflows/` - CI/CD workflows