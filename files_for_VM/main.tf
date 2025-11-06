terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.32"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "olake" {
  name       = "olake"
  repository = "https://datazip-inc.github.io/olake-helm"
  chart      = "olake"
  namespace  = "default"
  values = [
    file("values.yaml")
  ]
}
