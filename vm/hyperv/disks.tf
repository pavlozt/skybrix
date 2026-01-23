resource "hyperv_vhd" "os_disk" {
  path        = "${var.provider_opts.hyperv_path_prefix}\\${var.name}\\${var.name}_root.vhdx"
  vhd_type    = "Differencing"
  parent_path = "${var.provider_opts.hyperv_root_images}\\${var.image_id}.vhdx"
}


resource "hyperv_vhd" "extra_disk" {
  for_each = var.extra_disks

  path     = "${var.provider_opts.hyperv_path_prefix}\\${var.name}\\${each.key}.vhdx"
  vhd_type = "Dynamic"
  size     = each.value.size * 1024 * 1024
}
