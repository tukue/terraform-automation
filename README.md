# Advanced Terraform Project

This project demonstrates an advanced Terraform setup for deploying infrastructure on Google Cloud Platform with proper tagging and modular structure.

## Infrastructure Architecture

```
                                   ┌─────────────────┐
                                   │                 │
                                   │  Load Balancer  │
                                   │                 │
                                   └────────┬────────┘
                                            │
                                            ▼
┌─────────────────┐              ┌─────────────────────┐
│                 │              │                     │
│  VPC Network    │◄────────────►│  Compute Instances  │
│                 │              │                     │
└────────┬────────┘              └─────────────────────┘
         │                                  │
         │                                  │
         ▼                                  ▼
┌─────────────────┐              ┌─────────────────────┐
│                 │              │                     │
│    Firewall     │              │   Cloud SQL DB      │
│                 │              │                     │
└─────────────────┘              └─────────────────────┘
```

## Project Structure

- `main.tf` - Main configuration file
- `variables.tf` - Variable definitions
- `modules/` - Reusable modules
  - `tags/` - Common tagging module
  - `network/` - Network infrastructure
  - `database/` - Database resources
  - `compute/` - Compute instances
  - `loadbalancer/` - Load balancer configuration
- `environments/` - Environment-specific variable files
  - `qa.tfvars` - QA environment
  - `test.tfvars` - Test environment
  - `prod.tfvars` - Production environment

## Tagging Strategy

Resources are tagged with:
- Environment (qa, test, prod)
- Project ID
- Owner
- Department
- Cost Center

## Deployment Instructions

### For Linux/Mac:
```bash
./deploy.sh <environment>
```

### For Windows:
```cmd
test_deploy.bat <environment>
```

Where `<environment>` is one of: qa, test, prod

## Testing the Deployment

1. Initialize Terraform:
```
terraform init
```

2. Run a plan for a specific environment:
```
terraform plan -var-file="environments/qa.tfvars"
```

3. Apply the configuration:
```
terraform apply -var-file="environments/qa.tfvars"
```

## Infrastructure as Code Best Practices

- **Version Control**: All infrastructure code is stored in version control
- **Code Reviews**: Changes undergo peer review before deployment
- **Modular Design**: Resources organized into reusable modules
- **DRY Principle**: Common configurations extracted to avoid repetition
- **Consistent Formatting**: Code formatted with `terraform fmt`
- **Validation**: Pre-deployment validation with `terraform validate`
- **Documentation**: Resources and variables include descriptions
- **State Management**: Remote state with locking for team collaboration
- **Immutable Infrastructure**: Resources replaced rather than modified in-place
- **Automated Testing**: Infrastructure tested with Terratest or similar tools

## Best Practices

- **Modular Design**: Resources are organized into logical modules for better maintainability
- **Environment Separation**: Different configurations for qa, test, and prod environments
- **Resource Tagging**: Consistent tagging strategy for cost allocation and resource management
- **Least Privilege**: IAM roles follow principle of least privilege
- **Secure Networking**: VPC with proper firewall rules and network segmentation
- **State Management**: Remote state with locking for team collaboration
- **Parameterization**: Variables used for all environment-specific values
- **Version Pinning**: Terraform and provider versions are pinned for consistency

## Security Scanning

The project includes comprehensive security scanning using Terrascan, integrated in multiple ways:

1. **Local Scanning**: Use the PowerShell script for local development:
```powershell
.\scan-terraform.ps1 [directory]
```

2. **CI/CD Integration**: Enhanced GitHub Actions workflow automatically runs Terrascan on:
- All pull requests to main/master branches
- All pushes to main/master branches
- Manual triggers via workflow_dispatch

The automated security scanning includes:

### Basic Scan
- Validates infrastructure against security best practices
- Generates both JSON and human-readable reports
- Checks for common cloud misconfigurations

### Advanced Security Checks
- Dedicated high-severity issue scanning
- Separate analysis of medium-severity findings
- Configurable thresholds for different severity levels

### Reporting and Artifacts
- Detailed JSON reports for programmatic analysis
- Human-readable outputs for quick review
- Automated artifact storage of all scan results
- Summary reports in workflow logs

### Failure Conditions
- Automatic failure on ANY high-severity findings
- Warnings for excessive medium-severity issues (>5)
- Detailed error reporting and remediation guidance

### Security Policies
The scanning enforces policies including:
- SSL/TLS requirements for database connections
- Proper network security configurations
- IAM best practices
- Storage encryption requirements
- Resource access controls
- Network segmentation rules

### Viewing Results
Scan results can be accessed in multiple ways:
1. GitHub Actions workflow run summary
2. Downloaded artifacts from the workflow run
3. Local scan results in `terrascan-results.json`
4. Human-readable output in the workflow logs