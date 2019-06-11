provider "google" {
  region  = "${var.region}"
  project = "${var.project_name}"
  version = "2.8"
}
