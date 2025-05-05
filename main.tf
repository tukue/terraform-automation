provider "google" {
  project = var.project_id
  region  = var.region
}

# Network Module
module "network" {
  source      = "./modules/network"
  project_id  = var.project_id
  region      = var.region
  environment = var.environment
}

# Database Module
module "database" {
  source      = "./modules/database"
  db_name     = var.db_name
  db_instance = var.db_instance
  db_version  = var.db_version
  region      = var.region
  environment = var.environment
}

# Compute Module
module "compute" {
  source                = "./modules/compute"
  project_id            = var.project_id
  zone                  = var.zone
  instance_machine_type = var.instance_machine_type
  instance_count        = var.instance_count
  subnetwork_id         = module.network.subnetwork_id
  environment           = var.environment
}

# Load Balancer Module
module "loadbalancer" {
  source          = "./modules/loadbalancer"
  project_id      = var.project_id
  instance_group  = module.compute.instance_group
  health_check_id = module.compute.health_check_id
  environment     = var.environment
}

# Output the load balancer IP
output "load_balancer_ip" {
  description = "The IP address of the load balancer"
  value       = module.loadbalancer.load_balancer_ip
}

output "database_name" {
  description = "The name of the database"
  value       = module.database.db_name
}

output "environment" {
  description = "Current environment"
  value       = var.environment
}
