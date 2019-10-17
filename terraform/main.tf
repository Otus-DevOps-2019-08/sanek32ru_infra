terraform {
  # Версия terraform
  required_version = "0.12.10"
}

provider "google" {
  version = "2.15"
  project = var.project
  region  = var.region
}
