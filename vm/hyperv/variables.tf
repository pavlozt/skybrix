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


variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "name" {
  description = "Node name"
  type        = string
}


variable "image_id" {
  description = "OS Image family"
  type        = string
  default     = "debian-12-genericcloud"
}


variable "ssh_username" {
  description = "SSH username"
  type        = string
  default     = "ops"
}


variable "ssh_public_key_file" {
  description = "SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_key_fingerprint" {
  description = "Admin SSH Key fingerprint (for compatibility with DO)"
  type        = string
  default     = null
}

variable "ssh_allow_passwords" {
  description = "Allow password SSH login"
  type        = bool
  default     = false
}
variable "ssh_allow_root" {
  description = "Allow root SSH login"
  type        = bool
  default     = false
}

variable "hashed_passwd" {
  description = "Hash value (run: mkpasswd --method=SHA-512 --rounds=4096 )"
  type        = string
  default     = null
}

variable "all_inclusive" {
  description = "include all extra packages for admin comfort"
  type        = bool
  default     = false
}

variable "low_cost" {
  description = "Low cost instance (ignored for compatibility with other cloud modules)"
  type        = bool
  default     = false
}

variable "provider_opts" {
  description = <<DESC
Hyper-V provider additional configuration parameters.

Object structure:
- `hyperv_path_prefix`         (optional, string) - Base directory for Hyper-V virtual machines. Default: `c:\\vm`
- `hyperv_root_images`         (optional, string) - Directory for base VHDX images. Default: `c:\\vm\\root-images`
- `hyperv_cloudinit_disks`     (optional, string) - Directory for cloud-init ISO files. Default: `c:\\vm\\cloud-init-iso`
- `hyperv_network_switch_name` (optional, string) - Hyper-V virtual switch name. Default: `Default Switch`
DESC

  type = object({
    hyperv_path_prefix         = optional(string, "c:\\vm")
    hyperv_root_images         = optional(string, "c:\\vm\\root-images")
    hyperv_cloudinit_disks     = optional(string, "c:\\vm\\cloud-init-iso")
    hyperv_network_switch_name = optional(string, "Default Switch")
  })
  default = {}
}


