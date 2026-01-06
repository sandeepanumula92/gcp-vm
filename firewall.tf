resource "google_compute_firewall" "allow_argocd" {
  name    = "allow-argocd"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["argocd"]
}