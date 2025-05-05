# Instance Template
resource "google_compute_instance_template" "web_server_template" {
  name_prefix  = "${var.project_id}-template-${var.environment}-"
  machine_type = var.instance_machine_type

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
    # Larger disk for production
    disk_size_gb = var.environment == "prod" ? 20 : 10
  }

  network_interface {
    subnetwork = var.subnetwork_id
    access_config {
      # Ephemeral IP
    }
  }

  tags = ["http-server", "${var.environment}-instance"]

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    echo "<h1>Welcome to ${var.environment} environment</h1>" > /var/www/html/index.html
    echo "<p>Server: $(hostname)</p>" >> /var/www/html/index.html
    systemctl start apache2
    systemctl enable apache2
  EOT

  lifecycle {
    create_before_destroy = true
  }
}

# Instance Group Manager
resource "google_compute_instance_group_manager" "web_server_fleet" {
  name = "${var.project_id}-igm-${var.environment}"
  zone = var.zone
  
  base_instance_name = "web-server-${var.environment}"
  target_size        = var.instance_count

  version {
    instance_template = google_compute_instance_template.web_server_template.id
    name             = "primary"
  }

  named_port {
    name = "http"
    port = 80
  }
}

# Health Check
resource "google_compute_health_check" "http_health_check" {
  name               = "${var.project_id}-health-check-${var.environment}"
  check_interval_sec = 5
  timeout_sec        = 5

  http_health_check {
    port = 80
  }
}
