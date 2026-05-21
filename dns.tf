resource "cloudflare_dns_record" "A" {
  name    = var.domain
  zone_id = var.cloudflare_zone_id
  type    = "A"
  ttl     = 1
  content = data.kubernetes_service.ingress_nginx.status[0].load_balancer[0].ingress[0].ip
  proxied = false
}

resource "cloudflare_dns_record" "CNAME" {
  name    = "www.${cloudflare_dns_record.A.name}"
  zone_id = var.cloudflare_zone_id
  type    = "CNAME"
  ttl     = 1
  content = cloudflare_dns_record.A.name
  proxied = false
}
