# Cloud SQL Instance
resource "google_sql_database_instance" "db_instance" {
  name             = "${var.db_instance}-${var.environment}"
  database_version = var.db_version
  region           = var.region

  settings {
    # Use free tier (f1-micro) for dev/qa environments
    # Note: f1-micro is eligible for the GCP free tier
    tier = var.environment == "prod" ? "db-custom-2-7680" : (var.environment == "test" ? "db-custom-1-3840" : "db-f1-micro")
    
    # Reduce storage for free tier eligibility
    disk_size = var.environment == "dev" ? 10 : (var.environment == "qa" ? 10 : (var.environment == "test" ? 20 : 100))
    
    # High availability for production only
    availability_type = var.environment == "prod" ? "REGIONAL" : "ZONAL"
    
    # Backups for production and test, but not for dev/qa to save costs
    backup_configuration {
      enabled            = var.environment == "prod" || var.environment == "test"
      start_time         = "02:00"
      binary_log_enabled = var.environment == "prod"
    }
    
    ip_configuration {
      ipv4_enabled = true
      ssl_mode     = "ENCRYPTED_ONLY"
    }
    
    # Add user labels (tags)
    user_labels = var.tags
    
    # Maintenance settings to reduce costs
    maintenance_window {
      day  = 7  # Sunday
      hour = 4  # 4 AM
    }

    # Cost optimization settings
    insights_config {
      query_insights_enabled  = var.environment == "prod" || var.environment == "test"
      query_plans_per_minute  = var.environment == "prod" ? 5 : 0
      query_string_length     = 1024
      record_application_tags = false
      record_client_address   = false
    }
  }

  # Enable deletion protection for production only
  deletion_protection = var.environment == "prod"
}

# Database
resource "google_sql_database" "app_database" {
  name     = "${var.db_name}-${var.environment}"
  instance = google_sql_database_instance.db_instance.name
}