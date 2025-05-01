# Backend Service
resource "google_compute_backend_service" "web_backend" {
  name          = "${var.project_id}-backend"
  health_checks = [var.health_check_id]
  port_name     = "http"
  protocol      = "HTTP"

  backend {
    group = var.instance_group
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