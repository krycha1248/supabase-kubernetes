# resource "ovh_cloud_project_database" "postgres" {
#   service_name = var.ovh_service_name
#   flavor       = "b3-8"
#   engine       = "postgresql"
#   plan         = "discovery"
#   version      = "15"
#   nodes {
#     region = "WAW"
#   }

#   ip_restrictions {
#     ip = "${chomp(data.http.tf_controller_ip.response_body)}/32"
#     description = "Terraform controller IP"
#   }

#   ip_restrictions {
#     ip = "${chomp(ovh_cloud_project_gateway.gw.external_information[0].ips[0].ip)}/32"
#     description = "Kubernetes Cluster Gateway IP"
#   }
# }

# resource "ovh_cloud_project_database_database" "database" {
#   service_name = ovh_cloud_project_database.postgres.service_name
#   engine       = ovh_cloud_project_database.postgres.engine
#   cluster_id   = ovh_cloud_project_database.postgres.id
#   name         = "supabase"
# }

# resource "ovh_cloud_project_database_postgresql_user" "user" {
#   service_name   = ovh_cloud_project_database.postgres.service_name
#   cluster_id     = ovh_cloud_project_database.postgres.id
#   name           = "avnadmin"
#   roles          = ["replication"]
#   password_reset = "init"
# }

# data "http" "tf_controller_ip" {
#   url = "https://ifconfig.co/ip"
# }
