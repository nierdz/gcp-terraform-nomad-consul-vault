# Common
variable "region" {
  type = string
  default = "europe-west1"
}

variable "project_name" {
  type = string
  default = "terraform-nomad-consul-vault"
}

variable "ssh_user" {
  type = string
  default = "admin"
}

variable "ssh_pub_key" {
  type = string
  default = "~/.ssh/id_rsa.pub"
}

# Instance template
variable "machine_type" {
  type = string
  default = "n1-standard-1"
}

variable "target_tags" {
  type    = list(string)
  default = ["allow-service"]
}

variable "network" {
  type = string
  default = "tncv-network"
}

variable "disk_type" {
  type = string
  default = "pd-ssd"
}

variable "metadata" {
  type    = map(string)
  default = {}
}
