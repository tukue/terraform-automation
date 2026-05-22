package terraform

deny contains msg if {
    r := resource_changes[_]
    r.type == "google_sql_database_instance"
    after := r.change.after
    after.deletion_protection == false
    is_environment(r, "prod")

    msg := sprintf("PROD: %s must have deletion_protection enabled", [r.address])
}

deny contains msg if {
    r := resource_changes[_]
    r.type == "google_sql_database_instance"
    after := r.change.after
    settings := after.settings[_]
    settings.availability_type != "REGIONAL"
    is_environment(r, "prod")

    msg := sprintf("PROD: %s must use REGIONAL availability_type (found: %v)", [r.address, settings.availability_type])
}

deny contains msg if {
    r := resource_changes[_]
    r.type == "google_sql_database_instance"
    after := r.change.after
    settings := after.settings[_]
    backups := settings.backup_configuration[_]
    backups.enabled == false
    is_environment(r, "prod")

    msg := sprintf("PROD: %s must have backups enabled", [r.address])
}

deny contains msg if {
    r := resource_changes[_]
    r.type == "google_sql_database_instance"
    after := r.change.after
    settings := after.settings[_]
    backups := settings.backup_configuration[_]
    backups.binary_log_enabled == false
    is_environment(r, "prod")

    msg := sprintf("PROD: %s must have binary_log_enabled", [r.address])
}

deny contains msg if {
    r := resource_changes[_]
    r.type == "google_sql_database_instance"
    after := r.change.after
    settings := after.settings[_]
    ip_config := settings.ip_configuration[_]
    ip_config.ssl_mode != "ENCRYPTED_ONLY"

    msg := sprintf("VIOLATION: %s must use ssl_mode=ENCRYPTED_ONLY (found: %v)", [r.address, ip_config.ssl_mode])
}

deny contains msg if {
    r := resource_changes[_]
    r.type == "google_sql_database_instance"
    after := r.change.after
    settings := after.settings[_]
    settings.disk_size < 10

    msg := sprintf("VIOLATION: %s disk_size must be >= 10 GB (found: %v)", [r.address, settings.disk_size])
}

deny contains msg if {
    r := resource_changes[_]
    r.type == "google_sql_database_instance"
    after := r.change.after
    settings := after.settings[_]
    not startswith(settings.tier, "db-f1-micro")
    not startswith(settings.tier, "db-custom-")
    settings.tier != ""

    msg := sprintf("VIOLATION: %s uses unapproved tier: %v (allowed: db-f1-micro, db-custom-*)", [r.address, settings.tier])
}
