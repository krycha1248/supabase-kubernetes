resource "kubernetes_deployment_v1" "rest" {
  metadata {
    name      = "postgrest"
    namespace = kubernetes_namespace_v1.supabase.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = { app = "postgrest" }
    }

    template {
      metadata {
        labels = { app = "postgrest" }
      }

      spec {
        container {
          name  = "postgrest"
          image = "postgrest/postgrest:v14.8"

          env {
            name = "PGRST_DB_URI"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.supabase.metadata[0].name
                key  = "db_url"
              }
            }
          }

          env {
            name = "PGRST_JWT_SECRET"
          
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.supabase.metadata[0].name
                key  = "jwt_secret"
              }
            }
          }

          env {
            name  = "PGRST_DB_ANON_ROLE"
            value = "anon"
          }

          env {
            name  = "PGRST_DB_SCHEMAS"
            value = "public"
          }

          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "postgrest" {
  metadata {
    name      = "postgrest"
    namespace = kubernetes_namespace_v1.supabase.metadata[0].name
  }

  spec {
    selector = {
      app = "postgrest"
    }

    port {
      port        = 3000
      target_port = 3000
    }
  }
}