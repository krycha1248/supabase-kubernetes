resource "kubernetes_namespace_v1" "supabase" {
  metadata {
    name = "supabase"
  }
}

resource "helm_release" "supabase" {
  name       = "supabase"
  repository = "https://supabase-community.github.io/supabase-kubernetes"
  chart      = "supabase"
  namespace = kubernetes_namespace_v1.supabase.metadata[0].name
  timeout = 1200

  values = [templatefile("${path.module}/values.yaml.tpl", {
    domain      = var.domain
    supa_user   = var.supa_user
    supa_pass   = var.supa_pass
    anon_key   = jwt_hashed_token.anon.token
    service_key = jwt_hashed_token.service.token
    jwt_secret  = random_password.jwt_secret.result
  })]
}