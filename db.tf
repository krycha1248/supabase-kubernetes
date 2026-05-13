resource "ovh_cloud_project_database" "postgres" {
  service_name = var.ovh_service_name
  flavor       = "b3-8"
  engine       = "postgresql"
  plan         = "discovery"
  version      = "15"
  nodes {
    region = "WAW"
  }
}

resource "ovh_cloud_project_database_database" "database" {
  service_name = ovh_cloud_project_database.postgres.service_name
  engine       = ovh_cloud_project_database.postgres.engine
  cluster_id   = ovh_cloud_project_database.postgres.id
  name         = "supabase"
}

resource "ovh_cloud_project_database_postgresql_user" "user" {
  service_name   = ovh_cloud_project_database.postgres.service_name
  cluster_id     = ovh_cloud_project_database.postgres.id
  name           = "johndoe"
  roles          = ["replication"]
  password_reset = md5(random_password.db.result)
}

resource "random_password" "db" {
  length  = 32
  special = true
}
