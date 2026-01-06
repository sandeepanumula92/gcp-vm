variable "project_id" {
  description = "GCP project ID"
  type        = string

  validation {
    condition     = length(var.project_id) > 4
    error_message = "Project ID must be at least 5 characters."
  }
}

variable "region" {
  description = "GCP region (must support Always Free)"
  type        = string
  default     = "us-central1"

  validation {
    condition     = contains(["us-central1", "us-east1", "us-west1"], var.region)
    error_message = "Only Always Free regions are allowed."
  }
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"

  validation {
    condition     = can(regex("^us-(central|east|west)1-[a-c]$", var.zone))
    error_message = "Zone must belong to an Always Free region."
  }
}

variable "machine_type" {
  description = "VM machine type"
  type        = string
  default     = "e2-micro"

  validation {
    condition     = var.machine_type == "e2-micro"
    error_message = "Only e2-micro is allowed to stay within free tier."
  }
}

variable "disk_size_gb" {
  description = "Boot disk size (GB)"
  type        = number
  default     = 30

  validation {
    condition     = var.disk_size_gb <= 30
    error_message = "Always Free tier allows max 30GB standard disk."
  }
}

variable "gcp_sa_key" {
  description = "GCP Service Accoun Key"
  type        = string
}