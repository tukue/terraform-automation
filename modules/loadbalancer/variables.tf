variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "instance_group" {
  description = "The instance group resource"
  type        = string
}

variable "health_check_id" {
  description = "The ID of the health check"
  type        = string
}

variable "environment" {
  description = "Deployment environment (qa, test, prod)"
  type        = string
}
