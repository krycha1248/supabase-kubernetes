resource "kubernetes_deployment_v1" "auth" {
  metadata {
    name      = "gotrue"
    namespace = kubernetes_namespace_v1.supabase.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "gotrue"
      }
    }

    template {
      metadata {
        labels = {
          app = "gotrue"
        }
      }

      spec {
        container {
          name  = "gotrue"
          image = "supabase/gotrue:v2.186.0"

          env {
            name  = "GOTRUE_SITE_URL"
            value = "http://${var.domain}"
          }

          env {
            name  = "API_EXTERNAL_URL"
            value = "http://${var.domain}"
          }

          env {
            name  = "GOTRUE_API_HOST"
            value = "0.0.0.0"
          }

          env {
            name  = "GOTRUE_API_PORT"
            value = "9999"
          }

          env {
            name = "DATABASE_URL"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.supabase.metadata[0].name
                key  = "db_url"
              }
            }
          }

          env {
            name = "GOTRUE_JWT_SECRET"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.supabase.metadata[0].name
                key  = "jwt_secret"
              }
            }
          }

          env {
            name  = "GOTRUE_DISABLE_SIGNUP"
            value = "false"
          }

          env {
            name  = "GOTRUE_JWT_EXP"
            value = "3600"
          }

          env {
            name = "GOTRUE_DB_DRIVER"
            value = "postgres"
          }

          port {
            container_port = 9999
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "gotrue" {
  metadata {
    name      = "gotrue"
    namespace = kubernetes_namespace_v1.supabase.metadata[0].name
  }

  spec {
    selector = {
      app = "gotrue"
    }

    port {
      port        = 9999
      target_port = 9999
    }
  }
}