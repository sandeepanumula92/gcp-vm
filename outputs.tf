output "vm_name" {
  value = google_compute_instance.free_vm.name
}

output "vm_public_ip" {
  value = google_compute_instance.free_vm.network_interface[0].access_config[0].nat_ip
}

output "argocd_url" {
  value       = "https://${google_compute_instance.free_vm.network_interface[0].access_config[0].nat_ip}:32080"
  description = "Argo CD UI"
}

output "ssh_command" {
  value = "gcloud compute ssh ${google_compute_instance.free_vm.name} --zone ${var.zone}"
}