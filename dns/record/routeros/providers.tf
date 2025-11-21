terraform {
  required_providers {
    routeros = {
      source  = "terraform-routeros/routeros"
      version = ">= 1.9.1"
    }
  }
}

variable "name" {
  description = "DNS record name"
  type        = string
}

variable "ip" {
  description = "IP address"
  type        = string
}

variable "zone_name" {
  description = "DNS zone name"
  type        = string
}

variable "zone_suffix" {
  description = "Suffix to append to all record names in the zone. Optional."
  type        = string
  default     = ""
}
