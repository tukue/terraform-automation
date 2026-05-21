package terraform

allowed_machine_types := {
    "e2-micro",
    "e2-small",
    "e2-medium",
    "n2-standard-2",
    "n2-standard-4",
    "n2-standard-8",
    "n2-standard-16",
    "c2-standard-4",
    "c2-standard-8",
}

deny contains msg if {
    r := resource_changes[_]
    r.type == "google_compute_instance_template"
    after := r.change.after
    not allowed_machine_types[after.machine_type]

    msg := sprintf("VIOLATION: %s uses unapproved machine_type: %v", [r.address, after.machine_type])
}

deny contains msg if {
    r := resource_changes[_]
    r.type == "google_compute_instance_template"
    after := r.change.after
    disk := after.disk[_]
    disk.boot == true
    disk.disk_size_gb < 10

    msg := sprintf("VIOLATION: %s boot disk must be >= 10 GB (found: %v)", [r.address, disk.disk_size_gb])
}

deny contains msg if {
    r := resource_changes[_]
    r.type == "google_compute_instance_template"
    after := r.change.after
    disk := after.disk[_]
    disk.boot == true
    disk.disk_size_gb > 100

    msg := sprintf("VIOLATION: %s boot disk must be <= 100 GB (found: %v)", [r.address, disk.disk_size_gb])
}

deny contains msg if {
    r := resource_changes[_]
    r.type == "google_compute_instance_template"
    after := r.change.after
    after.can_ip_forward == true

    msg := sprintf("VIOLATION: %s must not have can_ip_forward enabled", [r.address])
}
