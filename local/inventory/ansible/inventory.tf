variable "hosts" {
  description = "List of hosts with name,ip, ssh_username"
  type = list(object({
    name         = string
    ip           = string
    ssh_username = string
  }))
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


resource "local_file" "ansible_hosts_file" {
  filename = var.inventory_file
  content = templatefile("${path.module}/ansible-hosts.tftpl", {
    hosts     = var.hosts
    groupname = var.groupname
  })
  file_permission = "0644"
}
