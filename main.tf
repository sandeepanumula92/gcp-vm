resource "google_compute_instance" "free_vm" {
  name         = "free-tier-vm"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = var.disk_size_gb
      type  = "pd-standard"
    }
  }

  network_interface {
    network = "default"

    access_config {} # ephemeral public IP
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  metadata_startup_script = file("${path.module}/startup-script.sh")

  tags = ["free-tier", "k3s", "argocd"]

  lifecycle {
    precondition {
      condition     = var.machine_type == "e2-micro"
      error_message = "Precondition failed: VM must be e2-micro for free tier."
    }

    precondition {
      condition     = var.disk_size_gb <= 30
      error_message = "Precondition failed: Disk exceeds free tier limit."
    }

    postcondition {
      condition     = self.boot_disk[0].initialize_params[0].size <= 30
      error_message = "Postcondition failed: Disk size exceeded after creation."
    }
  }
}