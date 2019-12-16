resource "google_compute_region_instance_group_manager" "consul_vault" {
  name               = "consul-vault-igm"
  base_instance_name = "consul-vault"
  instance_template  = "${google_compute_instance_template.consul_vault.self_link}"
  region             = "${var.region}"
}

resource "google_compute_region_autoscaler" "consul_vault" {
  name   = "consul-vault-autoscaler"
  target = "${google_compute_region_instance_group_manager.consul_vault.self_link}"

  autoscaling_policy {
    max_replicas    = 6
    min_replicas    = 3
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}
