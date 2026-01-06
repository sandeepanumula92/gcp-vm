provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
  credentials = var.gcp_sa_key
}