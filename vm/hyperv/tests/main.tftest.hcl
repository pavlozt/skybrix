provider "hyperv" {
  user     = var.hyperv_user
  password = var.hyperv_password
  host     = var.hyperv_host
  port     = var.hyperv_port
  https    = var.hyperv_https
  insecure = var.hyperv_insecure
  use_ntlm = true
  timeout  = "30s"
}


variable "hyperv_user" {
  description = "Username for Hyper-V authentication"
  type        = string
  default     = "Administrator"
  sensitive   = true
}

variable "hyperv_password" {
  description = "Password for Hyper-V authentication"
  type        = string
  sensitive   = true
}

variable "hyperv_host" {
  description = "Hyper-V host address"
  type        = string
}
variable "hyperv_port" {
  description = "Hyper-V host port"
  type        = number
  default     = 5986
}

variable "hyperv_https" {
  description = "Use HTTPS for Hyper-V connection"
  type        = bool
  default     = true
}

variable "hyperv_insecure" {
  description = "Allow insecure HTTPS connections"
  type        = bool
  default     = true
}

variable "provider_opts" {
  type    = any
  default = {}
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
    ssh_public_key_file = "~/.ssh/id_ed25519.pub"
    provider_opts       = var.provider_opts
  }

  assert {
    condition     = hyperv_machine_instance.vm.name == "${run.setup.pet}-dev"
    error_message = "VM name does not match expected pattern"
  }
  assert {
    condition     = hyperv_machine_instance.vm.state == "Running"
    error_message = "vm status not matched"
  }
  assert {
    condition     = length(hyperv_machine_instance.vm.hard_disk_drives) == 1
    error_message = "VM should have exactly one hard disk drive"
  }
  assert {
    condition     = length(hyperv_machine_instance.vm.dvd_drives) == 1
    error_message = "VM should have exactly one DVD drive"
  }

  assert {
    condition     = length(hyperv_machine_instance.vm.network_adaptors[0].ip_addresses) >= 1 && output.host_info.ip != ""
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
}
