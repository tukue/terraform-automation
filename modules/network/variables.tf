variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
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