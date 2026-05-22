package terraform

resource_changes := input.resource_changes

resources_of_type(type) := [r |
    r := resource_changes[_]
    r.type == type
] if true

is_environment(r, env) if {
    contains(r.address, sprintf("-%s", [env]))
}

is_environment(r, env) if {
    after := r.change.after
    after.name != null
    contains(after.name, sprintf("-%s", [env]))
}
