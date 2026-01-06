check "always_free_region_check" {
  assert {
    condition = contains(
      ["us-central1", "us-east1", "us-west1"],
      var.region
    )
    error_message = "Region is not eligible for Always Free tier."
  }
}

check "vm_machine_type_check" {
  assert {
    condition     = var.machine_type == "e2-micro"
    error_message = "Only e2-micro VMs are allowed."
  }
}

check "public_ip_attached" {
  assert {
    condition     = length(google_compute_instance.free_vm.network_interface[0].access_config) > 0
    error_message = "VM must have a public IP for SSH access."
  }
}