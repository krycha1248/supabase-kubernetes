resource "kubernetes_namespace_v1" "supabase" {
  depends_on = [ ovh_cloud_project_kube_nodepool.node_pool ]
  metadata {
    name = "supabase"
  }
}