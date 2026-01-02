resource "digitalocean_droplet" "vm" {
  image  = var.image_family
  name   = var.name_suffix != "" ? "${var.name}-${var.name_suffix}" : var.name
  region = var.region
  size   = local.final_slug
  tags   = ["env:${var.name_suffix}"]
  // This should suppress password creation and sending to email.
  ssh_keys = [var.ssh_key_fingerprint]
  user_data = templatefile(
    "${path.module}/../../common/cloud-init/templates/user-data.tftpl",
    {
      ssh_username         = var.ssh_username,
      ssh_public_key_file  = var.ssh_public_key_file,
      ssh_allow_root       = var.ssh_allow_root,
      ssh_allow_passwords  = var.ssh_allow_passwords,
      hashed_passwd        = var.hashed_passwd
      all_inclusive        = var.all_inclusive
      os_specific_packages = local.os_specific_packages
      force_network        = false
    }
  )
}

output "host_info" {
  description = "Host information for Ansible"
  value = {
    name         = digitalocean_droplet.vm.name
    ip           = digitalocean_droplet.vm.ipv4_address
    ssh_username = var.ssh_username
  }
}
