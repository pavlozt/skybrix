data "yandex_compute_image" "image_latest" {
  family = var.image_family
}

data "yandex_vpc_network" "default_network" {
  name = "default"
}

data "yandex_vpc_subnet" "default_subnet" {
  name = "default-ru-central1-a"
}

resource "yandex_compute_instance" "vm" {
  name        = var.name_suffix != "" ? "${var.name}-${var.name_suffix}" : var.name
  hostname    = var.name_suffix != "" ? "${var.name}-${var.name_suffix}" : var.name
  labels      = { "env" = "${var.name_suffix}" }
  platform_id = local.platform
  zone        = var.yandex_zone

  resources {
    cores         = local.cores
    memory        = local.memory
    core_fraction = local.core_fraction
  }
  scheduling_policy {
    preemptible = true
  }
  boot_disk {
    initialize_params {
      image_id = var.image_id != null ? var.image_id : data.yandex_compute_image.image_latest.id
      size     = local.boot_disk_size
      type     = local.boot_disk_type
    }
  }

  network_interface {
    nat       = true
    subnet_id = data.yandex_vpc_subnet.default_subnet.id
  }
  allow_stopping_for_update = true
  lifecycle {
    // do not recreate any new image changes
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }
  metadata = {
    user-data = templatefile(
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

}

output "host_info" {
  description = "Host information for Ansible"
  value = {
    name         = yandex_compute_instance.vm.name
    ip           = yandex_compute_instance.vm.network_interface[0].nat_ip_address
    ssh_username = var.ssh_username
  }
}
