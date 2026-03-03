variable "hosts" {
  description = "List of hosts with name,ip, ssh_username"
  type = list(object({
    name         = string
    ip           = string
    ssh_username = string
  }))
  # Validation to ensure the IP field is not an empty string
  validation {
    condition     = alltrue([for h in var.hosts : h.ip != ""])
    error_message = "The IP address for each host is mandatory and cannot be empty."
  }
}

variable "inventory_file" {
  description = "Directory to save inventory files"
  type        = string
  default     = "../hosts/dev/inventory.yaml"
}

variable "groupname" {
  description = "Name of inventory group to add all hosts"
  type        = string
  default     = "web"
}

variable "groups_hierarchy" {
  description = "Defines parent-child relationships between groups"
  type        = map(list(string)) # Key is parent group, value is list of children
  default     = {}
  # Example: { "web_all" = ["frontend", "backend"], "production" = ["web_all"] }
}

variable "hosts_vars" {
  description = "Map of host names to their variables"
  type        = map(map(string))
  default     = {}
}
