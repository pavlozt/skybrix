resource "random_id" "id" {
  byte_length = 8
}

locals {
  cloud_init_data_dir   = "${path.module}/cloud-init-data/${random_id.id.hex}"
  cloud_init_data_zip   = "${path.module}/cloud-init-data/${random_id.id.hex}.zip"
  remote_cloud_init_iso = "${var.provider_opts.hyperv_cloudinit_disks}\\${random_id.id.hex}.iso"
}

resource "local_file" "user_data" {
  content = templatefile(
    "${path.module}/../../common/cloud-init/templates/user-data.tftpl",
    {
      ssh_username         = "ops"
      ssh_public_key_file  = var.ssh_public_key_file
      ssh_allow_root       = var.ssh_allow_root
      ssh_allow_passwords  = var.ssh_allow_passwords
      all_inclusive        = var.all_inclusive
      hashed_passwd        = var.hashed_passwd
      os_specific_packages = local.os_specific_packages
      force_network        = true // TODO ??
    }
  )
  filename        = "${local.cloud_init_data_dir}/user-data"
  file_permission = "0644"
}

resource "local_file" "meta_data" {
  content = templatefile(
    "${path.module}/../../common/cloud-init/templates/meta-data.tftpl",
    {
      instance_id    = var.name
      local_hostname = var.name
    }
  )
  filename        = "${local.cloud_init_data_dir}/meta-data"
  file_permission = "0644"
}

data "archive_file" "cidata" {
  type        = "zip"
  source_dir  = local.cloud_init_data_dir
  output_path = local.cloud_init_data_zip
  depends_on  = [local_file.user_data, local_file.meta_data]
}



resource "hyperv_iso_image" "cidata" {
  volume_name               = "CIDATA"
  source_zip_file_path      = data.archive_file.cidata.output_path
  source_zip_file_path_hash = data.archive_file.cidata.output_sha
  destination_iso_file_path = local.remote_cloud_init_iso
  iso_media_type            = "cdr"
  iso_file_system_type      = "iso9660|joliet"
}
