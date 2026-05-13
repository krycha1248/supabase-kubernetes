resource "kubernetes_namespace_v1" "ingress_nginx" {
  depends_on = [ ovh_cloud_project_kube_nodepool.node_pool_d2_4 ]
  metadata {
    name = "ingress-nginx"
  }
}

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  namespace  = kubernetes_namespace_v1.ingress_nginx.metadata[0].name
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.11.0"

  set = [
    {
      name  = "controller.service.type"
      value = "LoadBalancer"
    },
    {
      name  = "controller.publishService.enabled"
      value = "true"
    }
  ]
}