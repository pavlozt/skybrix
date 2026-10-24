run "plan" {
  command = apply

  variables {
    inventory_file = "./testfile.yaml"
    groupname      = "web"
    hosts = [
      {
        name         = "frontend-01"
        ip           = "10.0.1.5"
        ssh_username = "ops"
      },
      {
        name         = "backend-01"
        ip           = "10.0.2.5"
        ssh_username = "ec2-user"
      }
    ]

    extra_groups = {
      docker = ["frontend-01"]
      monitor = ["missing-host"]
    }
  }

  assert {
    condition     = can(yamldecode(local_file.ansible_hosts_file.content).all.children["docker"])
    error_message = "Group 'docker' should be created for a host present in the 'hosts' list."
  }

  assert {
    condition     = !contains(keys(yamldecode(local_file.ansible_hosts_file.content).all.children), "monitor")
    error_message = "Group 'monitor' should not be created for a host not present in the 'hosts' list."
  }
}
