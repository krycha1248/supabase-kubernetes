resource "kubernetes_namespace_v1" "supabase" {
  depends_on = [helm_release.ingress_nginx, helm_release.cert_manager]
  metadata {
    name = "supabase"
  }
}

resource "helm_release" "supabase" {
  name       = "supabase"
  repository = "https://supabase-community.github.io/supabase-kubernetes"
  chart      = "supabase"
  namespace  = kubernetes_namespace_v1.supabase.metadata[0].name

  wait    = true
  timeout = 600

  values = [templatefile("${path.module}/values.yaml.tpl", {
    domain          = var.domain
    supa_user       = var.supa_user
    supa_pass       = var.supa_pass
    anon_key        = jwt_hashed_token.anon.token
    service_key     = jwt_hashed_token.service.token
    jwt_secret      = random_password.jwt_secret.result
    s3_region       = lower(ovh_cloud_project_storage.storage.region)
    s3_protocol     = "https"
    s3_endpoint     = ovh_cloud_project_storage.storage.virtual_host
    s3_storage_name = "data"
  })]
}

resource "kubernetes_secret" "supabase_s3" {
  metadata {
    name      = "supabase-s3"
    namespace = kubernetes_namespace_v1.supabase.metadata[0].name
  }

  data = {
    AWS_ACCESS_KEY_ID     = ovh_cloud_project_user_s3_credential.s3_credential.access_key_id
    AWS_SECRET_ACCESS_KEY = ovh_cloud_project_user_s3_credential.s3_credential.secret_access_key
  }
}
