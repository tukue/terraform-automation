package terraform

required_tags := {"environment", "managed_by", "owner", "department", "cost_center"}

tag_resource_types := {
    "google_sql_database_instance",
    "google_compute_instance_template",
}

resource_labels(r) := labels if {
    r.type == "google_sql_database_instance"
    settings := r.change.after.settings[_]
    labels := settings.user_labels
}

resource_labels(r) := labels if {
    r.type == "google_compute_instance_template"
    labels := r.change.after.metadata
}

deny contains msg if {
    r := resource_changes[_]
    tag_resource_types[r.type]
    r.change.actions[_] != "delete"
    labels := resource_labels(r)
    tag := required_tags[_]
    not labels[tag]

    msg := sprintf("VIOLATION: %s missing required tag '%s'", [r.address, tag])
}

deny contains msg if {
    r := resource_changes[_]
    r.type == "google_sql_database_instance"
    r.change.actions[_] != "delete"
    settings := r.change.after.settings[_]
    labels := settings.user_labels
    labels["managed_by"] != "terraform"

    msg := sprintf("VIOLATION: %s managed_by tag must be 'terraform' (found: %v)", [r.address, labels["managed_by"]])
}

deny contains msg if {
    r := resource_changes[_]
    r.type == "google_compute_instance_template"
    r.change.actions[_] != "delete"
    labels := r.change.after.metadata
    labels["managed-by"] != "terraform"

    msg := sprintf("VIOLATION: %s managed-by metadata must be 'terraform' (found: %v)", [r.address, labels["managed-by"]])
}
