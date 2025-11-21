provider "digitalocean" {
  token = var.do_token
}

variable "do_token" {
  type = string
}


run "setup" {
  module {
    source = "../../tests/pet/"
  }
}
run "plan" {
  command = plan
  variables {
    name = run.setup.pet
  }
}

run "create_vm" {
  command = apply
  variables {
    name                = run.setup.pet
    low_cost            = true
    size                = "small"
    ssh_public_key_file = "~/.ssh/id_rsa.pub"
    image_family        = "ubuntu-24-04-x64"
  }

  assert {
    condition     = digitalocean_droplet.vm.name == "${run.setup.pet}-dev"
    error_message = "VM name does not match expected pattern"
  }
  assert {
    condition     = digitalocean_droplet.vm.status == "active"
    error_message = "vm status not matched"
  }
  assert {
    condition     = digitalocean_droplet.vm.ipv4_address != null && output.host_info.ip != ""
    error_message = "VM IP address is empty"
  }
  assert {
    condition     = output.host_info.ip != null && output.host_info.ip != ""
    error_message = "Output IP address is empty"
  }
  assert {
    condition     = can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$", output.host_info.ip))
    error_message = "Output IP address is not a valid IPv4 address"
  }
  assert {
    condition     = output.host_info.ssh_username == "ops"
    error_message = "SSH username is not 'ops'"
  }
  assert {
    condition     = digitalocean_droplet.vm.user_data != null
    error_message = "VM metadata is null"
  }
}
