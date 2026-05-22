package terraform

deny contains msg if {
    r := resource_changes[_]
    r.type == "google_compute_subnetwork"
    after := r.change.after
    after.log_config == null

    msg := sprintf("VIOLATION: %s must have VPC flow logs enabled", [r.address])
}

deny contains msg if {
    r := resource_changes[_]
    r.type == "google_compute_subnetwork"
    after := r.change.after
    log := after.log_config[_]
    log.flow_sampling < 0.1

    msg := sprintf("VIOLATION: %s flow log sampling rate must be >= 0.1 (found: %v)", [r.address, log.flow_sampling])
}

deny contains msg if {
    r := resource_changes[_]
    r.type == "google_compute_firewall"
    after := r.change.after
    after.direction != "EGRESS"
    after.source_ranges[_] == "0.0.0.0/0"
    after.allow[_].ports[_] == "22"

    msg := sprintf("VIOLATION: %s allows SSH (port 22) from 0.0.0.0/0", [r.address])
}

deny contains msg if {
    r := resource_changes[_]
    r.type == "google_compute_firewall"
    after := r.change.after
    after.direction != "EGRESS"
    after.source_ranges[_] == "0.0.0.0/0"
    after.allow[_].ports[_] == "3389"

    msg := sprintf("VIOLATION: %s allows RDP (port 3389) from 0.0.0.0/0", [r.address])
}

deny contains msg if {
    r := resource_changes[_]
    r.type == "google_compute_firewall"
    after := r.change.after
    after.direction != "EGRESS"
    after.source_ranges[_] == "0.0.0.0/0"
    after.allow[_].protocol == "all"

    msg := sprintf("VIOLATION: %s allows all protocols from 0.0.0.0/0", [r.address])
}

deny contains msg if {
    r := resource_changes[_]
    r.type == "google_compute_firewall"
    after := r.change.after
    after.direction == "INGRESS"
    after.disabled == true

    msg := sprintf("INFO: %s is disabled - consider removing if unused", [r.address])
}
