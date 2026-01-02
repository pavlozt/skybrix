resource "routeros_dns_record" "a_record" {
  name    = var.zone_suffix != "" ? "${var.name}.${var.zone_suffix}.${var.zone_name}" : "${var.name}.${var.zone_name}"
  address = var.ip
  type    = "A"
  ttl     = 60
}
