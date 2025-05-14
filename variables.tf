variable "environment" {
  description = "Deployment environment (qa, test, prod)"
  type        = string
  default     = "dev"
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "zone" {
  description = "GCP Zone"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_instance" {
  description = "Database instance name"
  type        = string
}

variable "db_version" {
  description = "Database version"
  type        = string
}

variable "instance_machine_type" {
  description = "Instance machine type"
  type        = string
}

variable "instance_count" {
  description = "Number of instances in the fleet"
  type        = number
}

# Tag-related variables
variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "infrastructure-team"
}

variable "department" {
  description = "Department responsible for the resources"
  type        = string
  default     = "engineering"
}

variable "cost_center" {
  description = "Cost center for billing purposes"
  type        = string
  default     = "cc-123456"
}