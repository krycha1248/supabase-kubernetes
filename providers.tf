terraform {
  backend "s3" {
    bucket = "krywlo-terraform-state"
    endpoints = {
      s3 = "https://s3.waw.io.cloud.ovh.net/"
    }
    skip_credentials_validation = true
    skip_region_validation      = true
    use_path_style              = true
    skip_requesting_account_id  = true
    key                         = "terraform.tfstate"
    region                      = "waw"
    use_lockfile                = false
  }

  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }

    ovh = {
      source = "ovh/ovh"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.25"
    }

    helm = {
      source = "hashicorp/helm"
    }

    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
}

provider "openstack" {
  auth_url    = "https://auth.cloud.ovh.net/"
  domain_name = "default"
}

provider "ovh" {
  endpoint = "ovh-eu"
}

provider "kubernetes" {
  host                   = ovh_cloud_project_kube.kubernetes_cluster.kubeconfig_attributes[0].host
  client_certificate     = base64decode(ovh_cloud_project_kube.kubernetes_cluster.kubeconfig_attributes[0].client_certificate)
  client_key             = base64decode(ovh_cloud_project_kube.kubernetes_cluster.kubeconfig_attributes[0].client_key)
  cluster_ca_certificate = base64decode(ovh_cloud_project_kube.kubernetes_cluster.kubeconfig_attributes[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes = {
    host                   = ovh_cloud_project_kube.kubernetes_cluster.kubeconfig_attributes[0].host
    client_certificate     = base64decode(ovh_cloud_project_kube.kubernetes_cluster.kubeconfig_attributes[0].client_certificate)
    client_key             = base64decode(ovh_cloud_project_kube.kubernetes_cluster.kubeconfig_attributes[0].client_key)
    cluster_ca_certificate = base64decode(ovh_cloud_project_kube.kubernetes_cluster.kubeconfig_attributes[0].cluster_ca_certificate)
  }
}

provider "kubectl" {
  host                   = ovh_cloud_project_kube.kubernetes_cluster.kubeconfig_attributes[0].host
  client_certificate     = base64decode(ovh_cloud_project_kube.kubernetes_cluster.kubeconfig_attributes[0].client_certificate)
  client_key             = base64decode(ovh_cloud_project_kube.kubernetes_cluster.kubeconfig_attributes[0].client_key)
  cluster_ca_certificate = base64decode(ovh_cloud_project_kube.kubernetes_cluster.kubeconfig_attributes[0].cluster_ca_certificate)
  load_config_file       = false
}