# Advanced Terraform Project

This project demonstrates an advanced Terraform setup for deploying infrastructure on Google Cloud Platform with proper tagging and modular structure.

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