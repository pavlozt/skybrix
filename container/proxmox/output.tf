output "host_info" {
  description = "Host information for Ansible"
  value = {
    name         = var.name
    ip           = try(split("/", proxmox_lxc_guest.container.network[0].ipv4_address)[0], null)
    ssh_username = "root"
  }
}
