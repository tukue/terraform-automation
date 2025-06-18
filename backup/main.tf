provider "google" {
  project = var.project_id
  region  = var.region
}

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

# Cloud SQL Instance
resource "google_sql_database_instance" "db_instance" {
  name             = var.db_instance
  database_version = var.db_version
  region           = var.region

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = true
      ssl_mode     = "REQUIRE_SSL"  # Changed from "REQUIRE" to "REQUIRE_SSL"
    }
  }

  deletion_protection = false  # Set to true for production
}

# Database
resource "google_sql_database" "app_database" {
  name     = var.db_name
  instance = google_sql_database_instance.db_instance.name
}

# Instance Template
resource "google_compute_instance_template" "web_server_template" {
  name_prefix  = "${var.project_id}-template-"
  machine_type = var.instance_machine_type

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
    disk_size_gb = 10
  }

  network_interface {
    subnetwork = google_compute_subnetwork.app_subnetwork.id
    access_config {
      # Ephemeral IP
    }
  }

  tags = ["http-server"]

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2
  EOT

  lifecycle {
    create_before_destroy = true
  }
}

# Instance Group Manager
resource "google_compute_instance_group_manager" "web_server_fleet" {
  name = "${var.project_id}-igm"
  zone = var.zone
  
  base_instance_name = "web-server"
  target_size        = var.instance_count

  version {
    name              = "primary"
    instance_template = google_compute_instance_template.web_server_template.id
  }

  named_port {
    name = "http"
    port = 80
  }
}

# Health Check
resource "google_compute_health_check" "http_health_check" {
  name               = "${var.project_id}-health-check"
  check_interval_sec = 5
  timeout_sec        = 5

  http_health_check {
    port = 80
  }
}

# Backend Service
resource "google_compute_backend_service" "web_backend" {
  name          = "${var.project_id}-backend"
  health_checks = [google_compute_health_check.http_health_check.id]
  port_name     = "http"
  protocol      = "HTTP"

  backend {
    group = google_compute_instance_group_manager.web_server_fleet.instance_group
  }
}

# URL Map
resource "google_compute_url_map" "web_url_map" {
  name            = "${var.project_id}-url-map"
  default_service = google_compute_backend_service.web_backend.id
}

# HTTP Proxy
resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "${var.project_id}-http-proxy"
  url_map = google_compute_url_map.web_url_map.id
}

# Global Forwarding Rule
resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
  name       = "${var.project_id}-forwarding-rule"
  target     = google_compute_target_http_proxy.http_proxy.id
  port_range = "80"
}
