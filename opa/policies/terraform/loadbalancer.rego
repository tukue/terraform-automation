package terraform

deny contains msg if {
    r := resource_changes[_]
    r.type == "google_compute_backend_service"
    after := r.change.after
    after.enable_cdn == false
    is_environment(r, "prod")

    msg := sprintf("PROD: %s must have CDN enabled", [r.address])
}

deny contains msg if {
    r := resource_changes[_]
    r.type == "google_compute_backend_service"
    after := r.change.after
    after.protocol != "HTTP"
    after.protocol != "HTTPS"

    msg := sprintf("VIOLATION: %s must use HTTP or HTTPS protocol (found: %v)", [r.address, after.protocol])
}

deny contains msg if {
    r := resource_changes[_]
    r.type == "google_compute_forwarding_rule"
    after := r.change.after
    after.port_range != "80"
    after.port_range != "443"
    is_environment(r, "prod")

    msg := sprintf("VIOLATION: %s must use port 80 or 443 (found: %v)", [r.address, after.port_range])
}
