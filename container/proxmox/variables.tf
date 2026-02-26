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

variable "image_family" {
  type        = string
  description = "Ignored"
  default     = null
}
variable "image_id" {
  type        = string
  description = "Update and download by running commands: pveam available | grep debian-12-standard"

}

variable "name" {
  description = "Node name"
  type        = string
}

variable "ssh_public_key_file" {
  description = "SSH public key file"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "ssh_allow_passwords" {
  description = "Allow password SSH login"
  type        = bool
  default     = false
}

variable "provider_opts" {
  description = <<DESC
Proxmox provider additional configuration parameters.

Object structure:
- `pm_target_node`         (optional, string) - Target Proxmox node where resources will be created. Default: `"pve1"`.
- `pm_root_disk_storage`   (optional, string) - Storage for the root disk of the virtual machine. Default: `"local"`.
- `pm_template_storage`    (optional, string) - Storage where templates (images) for creating VMs are located. Default: `"local"`.
- `pm_network_bridge_name` (optional, string) - Name of the network bridge to which the VM will be connected. Default: `"vmbr1"`.
DESC

  type = object({
    pm_target_node         = optional(string, "pve1")
    pm_root_disk_storage   = optional(string, "local")
    pm_template_storage    = optional(string, "local")
    pm_network_bridge_name = optional(string, "vmbr1")
  })

  default = {}
}


variable "ipv4_address" {
  description = "Network static IP address"
}
variable "ipv4_gateway" {
  description = "Network  IP gateway"
}

variable "extra_disks" {
  description = "Additional disks"
  type = map(object({
    size       = number
    type       = string
    mountpoint = string
  }))
  default = {}
}

