locals {
  region = "WAW1"
}

resource "ovh_cloud_project_kube" "kubernetes_cluster" {
  service_name = var.ovh_service_name
  name         = "supabase"
  region       = local.region

  private_network_id = tolist(
    ovh_cloud_project_network_private.net.regions_attributes[*].openstackid
  )[0]

  nodes_subnet_id = ovh_cloud_project_network_private_subnet.subnet.id

  private_network_configuration {
    private_network_routing_as_default = true
    default_vrack_gateway              = ovh_cloud_project_gateway.gw.interfaces[0].ip
  }
}

resource "ovh_cloud_project_kube_nodepool" "node_pool" {
  service_name  = var.ovh_service_name
  kube_id       = ovh_cloud_project_kube.kubernetes_cluster.id
  name          = "workers-d2-8"
  flavor_name   = "d2-8"
  autoscale     = true
  desired_nodes = 1
  max_nodes     = 1
  min_nodes     = 1
}
