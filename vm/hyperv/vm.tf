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
