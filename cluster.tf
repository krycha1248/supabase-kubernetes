resource "ovh_cloud_project_kube" "kubernetes_cluster" {
  service_name = var.ovh_service_name
  name         = "Kubernetes Cluster"
  region       = "WAW1"
}

resource "ovh_cloud_project_kube_nodepool" "node_pool_d2_4" {
  service_name  = var.ovh_service_name
  kube_id       = ovh_cloud_project_kube.kubernetes_cluster.id
  name          = "workers-d2-4"
  flavor_name   = "d2-4"
  autoscale     = true
  desired_nodes = 1
  max_nodes     = 2
  min_nodes     = 1
}