output "instance_group" {
  description = "The instance group resource"
  value       = google_compute_instance_group_manager.web_server_fleet.instance_group
}

output "health_check_id" {
  description = "The ID of the health check"
  value       = google_compute_health_check.http_health_check.id
}