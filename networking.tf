resource "ovh_cloud_project_network_private" "net" {
  service_name = var.ovh_service_name
  name         = "supabase-net"
  regions      = ["WAW1"]
  vlan_id      = 10
}

resource "ovh_cloud_project_network_private_subnet" "subnet" {
  service_name = ovh_cloud_project_network_private.net.service_name
  network_id   = ovh_cloud_project_network_private.net.id

  region  = "WAW1"
  network = "192.168.0.0/24"

  start = "192.168.0.2"
  end   = "192.168.0.254"

  dhcp = true
  no_gateway = false
}

resource "ovh_cloud_project_gateway" "gw" {
  service_name = var.ovh_service_name
  name         = "supabase-gw"
  model        = "s"
  region       = ovh_cloud_project_network_private_subnet.subnet.region

  network_id = tolist(
    ovh_cloud_project_network_private.net.regions_attributes[*].openstackid
  )[0]

  subnet_id = ovh_cloud_project_network_private_subnet.subnet.id
}