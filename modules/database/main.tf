# Cloud SQL Instance
resource "google_sql_database_instance" "db_instance" {
  name             = "${var.db_instance}-${var.environment}"
  database_version = var.db_version
  region           = var.region

  settings {
    # Different tiers based on environment
    tier = var.environment == "prod" ? "db-custom-2-7680" : (var.environment == "test" ? "db-custom-1-3840" : "db-f1-micro")
    
    # High availability for production only
    availability_type = var.environment == "prod" ? "REGIONAL" : "ZONAL"
    
    # Backups for production and test
    backup_configuration {
      enabled            = var.environment == "prod" || var.environment == "test"
      start_time         = "02:00"
      binary_log_enabled = var.environment == "prod"
    }
    
    ip_configuration {
      ipv4_enabled = true
      ssl_mode     = "REQUIRE"
    }
    
    # Add user labels (tags)
    user_labels = var.tags
  }

  # Enable deletion protection for production
  deletion_protection = var.environment == "prod"
}

# Database
resource "google_sql_database" "app_database" {
  name     = "${var.db_name}-${var.environment}"
  instance = google_sql_database_instance.db_instance.name
}