resource "proxmox_lxc_guest" "container" {
  name            = var.name
  power_state     = "running"
  target_node     = var.provider_opts.pm_target_node
  unprivileged    = true
  password        = ""
  ssh_public_keys = file(pathexpand(var.ssh_public_key_file))
  template {
    file    = var.image_id
    storage = var.provider_opts.pm_template_storage
  }
  cpu {
    cores = local.cores
  }
  features {
    unprivileged {
      nesting = true
    }
  }


  dynamic "mount" {
    # iterate over keys to have a stable index for the 'slot' (mp0, mp1, etc.)
    for_each = keys(var.extra_disks)
    content {
      slot       = "mp${mount.key}"
      storage    = var.extra_disks[mount.value].type
      guest_path = var.extra_disks[mount.value].mountpoint
      size       = "${var.extra_disks[mount.value].size}G"
    }
  }
  root_mount {
    size    = "${local.params.boot_disk_size}G"
    storage = var.provider_opts.pm_root_disk_storage
  }
  memory             = local.memory * 1024
  swap               = 0
  start_at_node_boot = true

  network {
    id           = 0
    name         = "eth0"
    ipv4_dhcp    = false
    bridge       = var.provider_opts.pm_network_bridge_name
    ipv4_address = var.ipv4_address
    ipv4_gateway = var.ipv4_gateway
  }
  startup_shutdown {}
}
