# resource "ovh_cloud_project_storage" "storage" {
#   service_name = var.ovh_service_name
#   region_name = "WAW"
#   name = "krywlo-supabase-storage"
# }

# resource "ovh_cloud_project_user" "user" {
#   service_name = var.ovh_service_name
#   description  = "user for supabase storage access"
#   role_names   = [
#     "objectstore_operator"
#   ]
# }

# resource "ovh_cloud_project_user_s3_credential" "my_s3_credentials" {
#   service_name = var.ovh_service_name
#   user_id      = ovh_cloud_project_user.user.id
# }