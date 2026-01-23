resource "yandex_compute_disk" "extra_disk" {
  for_each = var.extra_disks

  name = var.name_suffix != "" ? "${var.name}-${var.name_suffix}-${each.key}" : "${var.name}-${each.key}"
  size = each.value.size
  type = each.value.type
  zone = var.yandex_zone

  labels = {
    "vm" = "${var.name}"
  }
}