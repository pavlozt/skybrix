
variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "ams3"
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

variable "slug" {
  description = "A direct DigitalOcean slug (e.g., s-1vcpu-1gb). Mutually exclusive with 'size'."
  type        = string
  default     = null

  validation {
    # Condition is true if slug is null OR if it matches the regex pattern
    condition     = var.slug == null ? true : can(regex("^(s-|c-)[0-9]+vcpu-[0-9]+gb$", var.slug))
    error_message = "Slug format should match patterns like 's-1vcpu-1gb' or 'c-2vcpu-4gb'."
  }
}

variable "image_family" {
  description = "Droplet image"
  type        = string
  default     = "ubuntu-24-04-x64"
}

variable "image_id" {
  description = "Dummy variable for interface compatibility with other modules. DigitalOcean does not support exact image id."
  type        = string
  default     = null
}

variable "name_suffix" {
  description = "Name suffix for separate environments"
  type        = string
  default     = ""
}

variable "name" {
  description = "Droplet name"
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


// Does nothing. This variable for compatibility
variable "low_cost" {
  description = "Low cost instance"
  type        = bool
  default     = false
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

