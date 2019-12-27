resource "google_service_account" "server-admin" {
  account_id   = "server-admin"
  display_name = "server admin service account"
  description  = "used on server compute instances"
}

#resource "google_kms_key_ring" "tncv-key-ring" {
#  project  = var.project_name
#  name     = "tncv-key-ring"
#  location = var.region
#}

#resource "google_kms_crypto_key" "vault-key" {
#  name            = "vault-key"
#  key_ring        = google_kms_key_ring.tncv-key-ring.self_link
#  rotation_period = "86400s"
#}

resource "google_kms_key_ring_iam_binding" "vault_iam_kms_binding" {
  key_ring_id = format("%s/%s/tncv-key-ring", var.project_name, var.region)
  role = "roles/owner"

  members = [
    "serviceAccount:${google_service_account.server-admin.email}",
  ]
}

resource "google_project_iam_member" "project" {
  project = var.project_name
  role    = "roles/editor"
  member = "serviceAccount:${google_service_account.server-admin.email}"
}
