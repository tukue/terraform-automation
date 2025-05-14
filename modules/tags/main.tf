locals {
  # Common tags to be assigned to all resources
  common_tags = {
    environment = var.environment
    project     = var.project_id
    managed_by  = "terraform"
    owner       = var.owner
    department  = var.department
    cost_center = var.cost_center
  }
}

output "tags" {
  description = "Common tags map to be applied to all resources"
  value       = local.common_tags
}