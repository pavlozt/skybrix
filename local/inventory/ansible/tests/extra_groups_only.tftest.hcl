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
      db     = ["backend-01"]
      monitor = ["unknown-host"] # ignored because not present in `hosts`
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
    condition     = can(yamldecode(local_file.ansible_hosts_file.content).all.children["docker"])
    error_message = "Group 'docker' was not found in the inventory."
  }

  assert {
    condition     = can(yamldecode(local_file.ansible_hosts_file.content).all.children["docker"].hosts["frontend-01"])
    error_message = "Host 'frontend-01' is missing from 'docker'."
  }

  assert {
    condition     = can(yamldecode(local_file.ansible_hosts_file.content).all.children["db"])
    error_message = "Group 'db' was not found in the inventory."
  }

  assert {
    condition     = can(yamldecode(local_file.ansible_hosts_file.content).all.children["db"].hosts["backend-01"])
    error_message = "Host 'backend-01' is missing from 'db'."
  }

  assert {
    condition     = !can(yamldecode(local_file.ansible_hosts_file.content).all.children["monitor"])
    error_message = "Group 'monitor' should not be created for a host not present in the 'hosts' list."
  }
}