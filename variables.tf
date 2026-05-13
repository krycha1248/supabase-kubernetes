variable "ovh_service_name" {
  type      = string
  sensitive = true
}

variable "jwt_secret" {
  type = string
  sensitive = true
}

variable "domain" {
  default = "supabase.local"
  type = string
  sensitive = true
}