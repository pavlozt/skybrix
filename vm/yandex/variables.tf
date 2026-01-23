variable "yandex_zone" {
  description = "Yandex Cloud Zone"
  type        = string
  default     = "ru-central1-a"
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

variable "low_cost" {
  description = "Low cost instance"
  type        = bool
  default     = false
}

variable "image_family" {
  type        = string
  description = "OS image family. Low priority over image_id variable. (debian-12, centos-7, etc.) "
  default     = "ubuntu-2404-lts"
}
variable "image_id" {
  type        = string
  description = "OS image id from Yandex (yc compute image list --folder-id standard-images --limit 0 | grep ubuntu-24-04-lts)"
  default     = null
}

variable "name_suffix" {
  description = "Name suffix for separate environments"
  type        = string
  default     = ""
}

variable "name" {
  description = "Node name"
  type        = string
}

variable "ssh_username" {
  description = "SSH username"
  type        = string
  default     = "ops"
}


variable "ssh_public_key_file" {
  description = "SSH public key file"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "ssh_key_fingerprint" {
  // Using an SSH key prevents DigitalOcean from sending temporary password emails
  description = "Admin SSH Key fingerprint (disable temp password email)"
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

variable "provider_opts" {
  description = "Dummy variable for compatibility"
  type        = any
  default     = {}
}


variable "extra_disks" {
  description = "Additional disks"
  type = map(object({
    size = number
    type = string
  }))
  default = {}
}