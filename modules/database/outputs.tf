output "db_instance_name" {
  description = "The name of the database instance"
  value       = google_sql_database_instance.db_instance.name
}

output "db_name" {
  description = "The name of the database"
  value       = google_sql_database.app_database.name
}