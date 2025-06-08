# VPC Network
resource "google_compute_network" "app_network" {
  name                    = "${var.project_id}-network-${var.environment}"
  auto_create_subnetworks = false
  description             = "Main VPC network for ${var.environment} environment"
}

# Subnet
resource "google_compute_subnetwork" "app_subnetwork" {
  name          = "${var.project_id}-subnetwork-${var.environment}"
  ip_cidr_range = "10.0.0.0/24"
  network       = google_compute_network.app_network.id
  region        = var.region
  description   = "Application subnet for ${var.environment} environment"
  
  # Enable flow logs for better network monitoring
  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Firewall rule for HTTP
resource "google_compute_firewall" "allow_http" {
  name        = "${var.project_id}-allow-http-${var.environment}"
  network     = google_compute_network.app_network.id
  description = "Allow HTTP traffic to tagged instances"
  priority    = 1000

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

# Allow essential egress traffic
resource "google_compute_firewall" "allow_essential_egress" {
  name        = "${var.project_id}-allow-essential-egress-${var.environment}"
  network     = google_compute_network.app_network.id
  description = "Allow essential outbound traffic"
  priority    = 1000
  direction   = "EGRESS"

  allow {
    protocol = "tcp"
    ports    = ["80"] # HTTP only
  }

  destination_ranges = ["0.0.0.0/0"]
}
