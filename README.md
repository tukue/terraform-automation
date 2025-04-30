# Terraform GCP Infrastructure Automation

This repository contains Terraform configurations to automate the deployment of a scalable web application infrastructure on Google Cloud Platform (GCP). It includes resources for networking, compute, database, and load balancing.

## Features

- **VPC Network and Subnet**: Custom network and subnet for resource isolation.
- **Firewall Rules**: Allow HTTP traffic to web servers.
- **Cloud SQL Database**: PostgreSQL instance for application data.
- **Instance Template and Group**: Apache web server instances managed by an instance group.
- **Load Balancer**: HTTP load balancer with health checks, backend service, and URL mapping.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed.
- A GCP project with billing enabled.
- Service account credentials with the necessary permissions.

## Usage

1. Clone the repository:
   ```sh
   git clone https://github.com/tukue/terraform-automation.git
   cd terraform-automation