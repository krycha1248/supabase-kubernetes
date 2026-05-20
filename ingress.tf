resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

  depends_on = [
    ovh_cloud_project_kube_nodepool.node_pool
  ]

  wait    = true
  timeout = 600

  values = [
    yamlencode({
      controller = {
        service = {
          type = "LoadBalancer"
          annotations = {
            "loadbalancer.ovhcloud.com/class"                   = "octavia"
            "loadbalancer.openstack.org/timeout-client-data"    = "300000"
            "loadbalancer.openstack.org/timeout-member-connect" = "300000"
            "loadbalancer.openstack.org/timeout-member-data"    = "300000"
            "loadbalancer.openstack.org/connection-limit"       = "-1"
          }
        }
      }
    })
  ]
}

resource "helm_release" "cert_manager_crds" {
  name             = "cert-manager-crds"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true

  set = [
    {
      name  = "installCRDs"
      value = "true"
    },
    {
      name  = "startupapicheck.enabled"
      value = "false"
    }
  ]

  wait       = true
  timeout    = 300
  depends_on = [helm_release.ingress_nginx]
}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true

  depends_on = [
    helm_release.cert_manager_crds
  ]

  wait    = true
  timeout = 600

  set = [
    {
      name  = "startupapicheck.enabled"
      value = "false"
    }
  ]
}

resource "kubectl_manifest" "clusterissuer_letsencrypt_prod" {
  depends_on = [
    helm_release.cert_manager
  ]

  yaml_body = templatefile("${path.module}/clusterissuer.yaml.tpl", {
    email = var.email
  })
}

data "kubernetes_service" "ingress_nginx" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = helm_release.ingress_nginx.namespace
  }
}
