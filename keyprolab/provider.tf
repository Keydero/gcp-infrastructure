terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.53.1"
    }
  }
}

provider "google" {
  credentials = "./credentials/terraform-deployer.json"
  project     = var.project
  region      = "europe-west1"
}