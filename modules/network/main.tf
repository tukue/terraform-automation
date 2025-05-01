# VPC Network
resource "google_compute_network" "app_network" {
  name                    = "${var.project_id}-network"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "app_subnetwork" {
  name          = "${var.project_id}-subnetwork"
  ip_cidr_range = "10.0.0.0/24"
  network       = google_compute_network.app_network.id
  region        = var.region
}

# Firewall rule for HTTP
resource "google_compute_firewall" "allow_http" {
  name    = "${var.project_id}-allow-http"
  network = google_compute_network.app_network.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}