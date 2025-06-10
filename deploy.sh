#!/bin/bash

# Check if environment argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <environment>"
    echo "Available environments: qa, test, prod"
    exit 1
fi

ENV=$1

# Validate environment
if [[ "$ENV" != "qa" && "$ENV" != "test" && "$ENV" != "prod" ]]; then
    echo "Invalid environment. Choose from: qa, test, prod"
    exit 1
fi

echo "Deploying to $ENV environment..."

# Run security scan
echo "Running security scan..."
if command -v pwsh &> /dev/null; then
    pwsh ./scan-terraform.ps1
    SCAN_EXIT_CODE=$?
    if [ $SCAN_EXIT_CODE -ne 0 ]; then
        echo "Security scan failed! High severity vulnerabilities found."
        exit 1
    fi
else
    echo "PowerShell Core (pwsh) is required for security scanning but not found."
    echo "Please install PowerShell Core to enable security scanning."
    exit 1
fi

# Initialize Terraform if not already done
if [ ! -d ".terraform" ]; then
    echo "Initializing Terraform..."
    terraform init
fi

# Plan the deployment
echo "Planning deployment for $ENV environment..."
terraform plan -var-file="environments/${ENV}.tfvars" -out="${ENV}.tfplan"

# Ask for confirmation
read -p "Do you want to apply this plan? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Apply the plan
    echo "Applying plan for $ENV environment..."
    terraform apply "${ENV}.tfplan"
    
    # Show outputs
    echo "Deployment completed. Outputs:"
    terraform output
else
    echo "Deployment cancelled."
fi