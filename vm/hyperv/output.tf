output "host_info" {
  description = "Host information for Ansible"
  value = {
    name         = hyperv_machine_instance.vm.name
    ip           = try(hyperv_machine_instance.vm.network_adaptors[0].ip_addresses[0], null)
    ssh_username = var.ssh_username
  }
}
