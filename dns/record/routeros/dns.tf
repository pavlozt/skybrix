resource "routeros_dns_record" "a_record" {
  name    = var.zone_suffix != "" ? "${var.name}.${var.zone_suffix}.${var.zone_name}" : "${var.name}.${var.zone_name}"
  zone_id = data.cloudflare_zone.cf_zone.zone_id
  address = var.ip
  type    = "A"
  ttl     = 60
}
