resource "hyperv_vhd" "os_disk" {
  path = "${var.provider_opts.hyperv_path_prefix}\\${var.name}\\${var.name}_root.vhdx"
  # Empty image id means clear disk
  vhd_type    = (var.image_id == null || var.image_id == "") ? "Dynamic" : "Differencing"
  parent_path = (var.image_id == null || var.image_id == "") ? null : "${var.provider_opts.hyperv_root_images}\\${var.image_id}.vhdx"
  size = (var.image_id == null || var.image_id == "") ? local.boot_disk_size * 1024 * 1024 : null
}


resource "hyperv_vhd" "extra_disk" {
  for_each = var.extra_disks

  path     = "${var.provider_opts.hyperv_path_prefix}\\${var.name}\\${each.key}.vhdx"
  vhd_type = "Dynamic"
  size     = each.value.size * 1024 * 1024
}
