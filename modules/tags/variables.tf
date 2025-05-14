variable "environment" {
  description = "Deployment environment (qa, test, prod)"
  type        = string
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

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