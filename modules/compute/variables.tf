variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "zone" {
  description = "GCP Zone for compute resources"
  type        = string
}

variable "instance_machine_type" {
  description = "Machine type for compute instances"
  type        = string
  default     = "e2-medium"
}

variable "instance_count" {
  description = "Number of instances to create in the instance group"
  type        = number
  default     = 2
  
  validation {
    condition     = var.instance_count > 0 && var.instance_count <= 10
    error_message = "Instance count must be between 1 and 10."
  }
}

variable "subnetwork_id" {
  description = "ID of the subnetwork to deploy instances in"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, qa, test, prod)"
  type        = string
  
  validation {
    condition     = contains(["dev", "qa", "test", "prod"], var.environment)
    error_message = "Environment must be one of: dev, qa, test, prod."
  }
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}