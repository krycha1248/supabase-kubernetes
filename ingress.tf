resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  create_namespace = true
  depends_on = [ ovh_cloud_project_gateway.gw ]

  values = [
    yamlencode({
      controller = {
        service = {
          type = "LoadBalancer"
        }
      }
    })
  ]
}

data "kubernetes_service" "ingress_nginx" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = helm_release.ingress_nginx.namespace
  }
}