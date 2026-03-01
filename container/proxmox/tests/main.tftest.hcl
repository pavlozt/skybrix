provider "proxmox" {
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = var.pm_tls_insecure

  pm_debug = false

}

variable "size" {
  description = "A predefined size (e.g., tiny, small). Mutually exclusive with 'slug'."
  type        = string
  default     = null

  validation {
    # Condition is true if size is null OR if it's a valid, non-null string
    condition     = var.size == null ? true : contains(["tiny", "small", "medium", "large"], var.size)
    error_message = "The 'size' value must be one of: tiny, small, medium, large."
  }
}

variable "pm_api_url" {
  type        = string
  description = "The URL of the Proxmox API endpoint (e.g., https://192.168.1.1:8006/api2/json)"
  # Example default: default = "https://proxmox.local:8006/api2/json"
}

variable "pm_api_token_id" {
  type        = string
  description = "The API Token ID in the format user@pam!tokenname"
  sensitive   = true
}

variable "pm_api_token_secret" {
  type        = string
  description = "The secret part of the API Token"
  sensitive   = true
}

variable "pm_tls_insecure" {
  type        = bool
  description = "Whether to skip TLS verification for the Proxmox API"
  default     = true
}

variable "provider_opts" {
  type = object({
    pm_target_node         = optional(string, "pve1")
    pm_root_disk_storage   = optional(string, "local")
    pm_template_storage    = optional(string, "local")
    pm_network_bridge_name = optional(string, "vmbr1")
  })

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

run "create_ct" {
  command = apply
  variables {
    name                = run.setup.pet
    size                = "small"
    ssh_public_key_file = "~/.ssh/id_ed25519.pub"
    provider_opts       = var.provider_opts
    extra_disks = {
      "data" = { size = 2, type = "slowcontainers", mountpoint = "/data/" },
      "logs" = { size = 3, type = "slowcontainers", mountpoint = "/logs/" }
    }
  }

  assert {
    condition     = proxmox_lxc_guest.container.name == "${run.setup.pet}"
    error_message = "Container name does not match expected pattern"
  }
  assert {
    condition     = proxmox_lxc_guest.container.power_state == "running"
    error_message = "Container status not matched"
  }
  assert {
    condition     = length(proxmox_lxc_guest.container.mount) == 2
    error_message = "Container should have exactly 2 mounts"
  }

  assert {
    condition     = length(proxmox_lxc_guest.container.network[0].ipv4_address) >= 1 && output.host_info.ip != ""
    error_message = "Container IP address is empty"
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
    condition     = output.host_info.ssh_username == "root"
    error_message = "SSH username is not 'root'"
  }
}
