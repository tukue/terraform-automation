variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "instance_group" {
  description = "Instance group for the load balancer"
  type        = string
}

variable "health_check_id" {
  description = "Health check ID"
  type        = string
}

variable "environment" {
  description = "Deployment environment (qa, test, prod)"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to resources"
  type        = map(string)
  default     = {}
}