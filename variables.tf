# Common
variable "region" {
  default = "europe-west1"
}

variable "project_name" {
  default = "terraform-nomad-consul-vault"
}

variable "ssh_user" {
  default = "admin"
}

variable "ssh_pub_key" {
  default = "~/.ssh/id_rsa.pub"
}

# Instance template
variable machine_type {
  default = "f1-micro"
}

variable target_tags {
  type    = "list"
  default = ["allow-service"]
}

variable instance_labels {
  type    = "map"
  default = {}
}

variable network {
  default = "default"
}

variable access_config {
  type = "list"
  default = [
    {},
  ]
}

variable compute_image {
  default = "tncv-image"
}

variable disk_type {
  default = "pd-ssd"
}

variable service_account_scopes {
  description = "List of scopes for the instance template service account"
  type        = "list"

  default = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
    "https://www.googleapis.com/auth/devstorage.full_control",
  ]
}

variable metadata {
  type    = "map"
  default = {}
}
