resource "kubernetes_secret_v1" "supabase" {
  metadata {
    name      = "supabase-secrets"
    namespace = kubernetes_namespace_v1.supabase.metadata[0].name
  }

  data = {
    jwt_secret = random_password.jwt_secret.result
    db_url = "postgresql://${local.db_user}:${local.db_password}@${local.db_host}:${local.db_port}/${local.db_name}?sslmode=require"
  }
}

locals {
  db_user     = ovh_cloud_project_database_postgresql_user.user.name
  db_password = urlencode(random_password.db.result)
  db_host     = ovh_cloud_project_database.postgres.endpoints[0].domain
  db_port     = ovh_cloud_project_database.postgres.endpoints[0].port
  db_name     = ovh_cloud_project_database_database.database.name
}

resource "random_password" "jwt_secret" {
  length           = 64
  special          = true
  override_special = "!@#$%^&*()-_=+"
}