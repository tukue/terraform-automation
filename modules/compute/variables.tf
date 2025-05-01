variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "zone" {
  description = "GCP Zone"
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

variable "subnetwork_id" {
  description = "The ID of the subnetwork"
  type        = string
}