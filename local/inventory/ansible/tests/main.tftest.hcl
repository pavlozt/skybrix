
run "plan" {
  command = apply
  variables {
    inventory_file = "./testfile.yaml"
    groupname      = "web"
    hosts = [
      {
        name         = "frontend-01"
        ip           = "10.0.1.5"
        ssh_username = "ops",
     },
      {
        name         = "backend-01"
        ip           = "10.0.2.5"
        ssh_username = "ec2-user"
      }
    ]
    hosts_vars = {
      "frontend-01" = {
        "hostname_full" = "frontend.domain.local"
      } 
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
    condition     = can(yamldecode(local_file.ansible_hosts_file.content).all.children[var.groupname])
    error_message = "Group '${var.groupname}' was not found in the inventory."
  }

}
