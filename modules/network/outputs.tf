output "network_id" {
  description = "The ID of the VPC network"
  value       = google_compute_network.app_network.id
}

output "subnetwork_id" {
  description = "The ID of the subnetwork"
  value       = google_compute_subnetwork.app_subnetwork.id
}