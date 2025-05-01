# Cloud SQL Instance
resource "google_sql_database_instance" "db_instance" {
  name             = var.db_instance
  database_version = var.db_version
  region           = var.region

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = true
    }
  }

  deletion_protection = false  # Set to true for production
}

# Database
resource "google_sql_database" "app_database" {
  name     = var.db_name
  instance = google_sql_database_instance.db_instance.name
}