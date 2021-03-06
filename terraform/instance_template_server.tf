resource "google_compute_instance_template" "server-it" {
  name_prefix  = "server-"
  machine_type = var.machine_type
  region       = var.region
  tags         = ["consul-server"]

  network_interface {
    network = var.network
    access_config {
    }
  }

  disk {
    auto_delete  = true
    boot         = true
    source_image = "server-image"
    type         = "PERSISTENT"
    disk_type    = var.disk_type
    mode         = "READ_WRITE"
  }

  service_account {
    email  = google_service_account.server-admin.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    startup-script = "${file("${path.module}/../scripts/startup-consul-vault.sh")}"
    sshKeys = "${var.ssh_user}:${file(var.ssh_pub_key)}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
