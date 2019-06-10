resource "google_compute_instance_template" "tncv" {
  name_prefix  = "tncv-"
  machine_type = "${var.machine_type}"
  region       = "${var.region}"
  tags         = ["allow-ssh","consul-server"]
  labels       = "${var.instance_labels}"

  network_interface {
    network = "${var.network}"
    access_config {
    }
  }

  disk {
    auto_delete  = true
    boot         = true
    source_image = "${var.compute_image}"
    type         = "PERSISTENT"
    disk_type    = "${var.disk_type}"
    mode         = "READ_WRITE"
  }

  service_account {
    scopes = ["cloud-platform"]
  }

  metadata = "${merge(
    map("startup-script", "${var.startup_script}", "sshKeys", "${var.ssh_user}:${file(var.ssh_pub_key)}"),
    var.metadata
  )}"

  lifecycle {
    create_before_destroy = true
  }
}
