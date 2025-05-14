output "network_id" {
  description = "The ID of the VPC network"
  value       = google_compute_network.app_network.id
}

output "subnetwork_id" {
  description = "The ID of the subnetwork"
  value       = google_compute_subnetwork.app_subnetwork.id
}

output "network_name" {
  description = "The name of the VPC network"
  value       = google_compute_network.app_network.name
}

output "firewall_tags" {
  description = "The tags used for firewall rules"
  value       = google_compute_firewall.allow_http.target_tags
}