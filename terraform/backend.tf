terraform {
  backend "gcs" {
    bucket = var.project_name
    prefix = "terraform/state"
  }
}
