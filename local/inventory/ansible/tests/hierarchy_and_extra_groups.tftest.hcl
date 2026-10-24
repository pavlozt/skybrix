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
      },
      {
        name         = "worker-01"
        ip           = "10.0.3.5"
        ssh_username = "ubuntu"
      }
    ]

    groups_hierarchy = {
      "production" = ["web"]
      "platform"   = ["production"]
    }

    extra_groups = {
      docker = ["frontend-01", "backend-01"]
      backup = ["worker-01"]
    }
  }

  assert {
    condition     = local_file.ansible_hosts_file.content != ""
    error_message = "Inventory file was not created or is empty."
  }

  assert {
    condition     = can(yamldecode(local_file.ansible_hosts_file.content))
    error_message = "The file is not valid YAML."
  }

  assert {
    condition     = can(yamldecode(local_file.ansible_hosts_file.content).all.children["web"])
    error_message = "Group 'web' was not found in the inventory."
  }

  assert {
    condition     = length(yamldecode(local_file.ansible_hosts_file.content).all.children["web"].hosts) == 3
    error_message = "Group 'web' should contain exactly 3 hosts."
  }

  assert {
    condition     = can(yamldecode(local_file.ansible_hosts_file.content).all.children["production"])
    error_message = "Parent group 'production' was not found in the inventory."
  }

  assert {
    condition     = can(yamldecode(local_file.ansible_hosts_file.content).all.children["production"].children["web"])
    error_message = "Group 'web' is not listed as a child of 'production'."
  }

  assert {
    condition     = can(yamldecode(local_file.ansible_hosts_file.content).all.children["platform"])
    error_message = "Parent group 'platform' was not found in the inventory."
  }

  assert {
    condition     = can(yamldecode(local_file.ansible_hosts_file.content).all.children["platform"].children["production"])
    error_message = "Group 'production' is not listed as a child of 'platform'."
  }

  assert {
    condition     = can(yamldecode(local_file.ansible_hosts_file.content).all.children["docker"])
    error_message = "Group 'docker' was not found in the inventory."
  }

  assert {
    condition     = length(yamldecode(local_file.ansible_hosts_file.content).all.children["docker"].hosts) == 2
    error_message = "Group 'docker' should contain exactly 2 hosts."
  }

  assert {
    condition     = can(yamldecode(local_file.ansible_hosts_file.content).all.children["docker"].hosts["frontend-01"])
    error_message = "Host 'frontend-01' is missing from 'docker'."
  }

  assert {
    condition     = can(yamldecode(local_file.ansible_hosts_file.content).all.children["backup"])
    error_message = "Group 'backup' was not found in the inventory."
  }

  assert {
    condition     = can(yamldecode(local_file.ansible_hosts_file.content).all.children["backup"].hosts["worker-01"])
    error_message = "Host 'worker-01' is missing from 'backup'."
  }
}