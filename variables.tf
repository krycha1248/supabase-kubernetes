variable "ovh_service_name" {
  type      = string
  sensitive = true
}

variable "cloudflare_zone_id" {
  type      = string
  sensitive = true
}

variable "domain" {
  type    = string
}

variable "supa_user" {
  type      = string
  sensitive = true
}

variable "supa_pass" {
  type      = string
  sensitive = true
}