data "cloudflare_zone" "cf_zone" {
  name = var.zone_name
}

resource "cloudflare_record" "node" {
  name            = var.zone_suffix != "" ? "${var.name}.${var.zone_suffix}" : var.name
  zone_id         = data.cloudflare_zone.cf_zone.zone_id
  content         = var.ip
  type            = "A"
  ttl             = 60
  proxied         = "false"
  allow_overwrite = true
}
