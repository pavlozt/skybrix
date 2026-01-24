resource "hyperv_machine_instance" "vm" {
  name                 = "${var.name}-${var.environment}"
  notes                = local.notes
  generation           = 2
  processor_count      = local.cores
  static_memory        = true
  memory_startup_bytes = local.memory * 1024 * 1024 * 1024
  vm_firmware {
    enable_secure_boot = "Off"
    boot_order {
      boot_type           = "HardDiskDrive"
      controller_number   = "0"
      controller_location = "0"
    }
  }

  network_adaptors {
    name        = "eth0"
    switch_name = var.provider_opts.hyperv_network_switch_name
  }

  hard_disk_drives {
    controller_type     = "Scsi"
    controller_number   = "0"
    controller_location = "0"
    path                = hyperv_vhd.os_disk.path
  }

  # Extra disks (Starting from Location 2)
  # We use dynamic block to iterate over the extra_disk resource map
  dynamic "hard_disk_drives" {
    for_each = [for i, k in keys(var.extra_disks) : {
      index = i
      key   = k
    }]

    content {
      controller_type   = "Scsi"
      controller_number = "0"
      # Start from location 2, so we add 2 to the current iteration index
      controller_location = hard_disk_drives.value.index + 2
      path                = hyperv_vhd.extra_disk[hard_disk_drives.value.key].path
    }
  }

  # cloud-init drive
  dvd_drives {
    controller_number   = "0"
    controller_location = "1"
    path                = "${var.provider_opts.hyperv_cloudinit_disks}\\${random_id.id.hex}.iso"
    resource_pool_name  = ""
  }

  depends_on = [hyperv_iso_image.cidata]
  // workaround

  lifecycle {
    ignore_changes = [
      dvd_drives[0].resource_pool_name,
      hard_disk_drives[0].path,
      vm_processor
    ]
  }

}
