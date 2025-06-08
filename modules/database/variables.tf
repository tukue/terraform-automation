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

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, qa, test, prod)"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to resources"
  type        = map(string)
  default     = {}
}