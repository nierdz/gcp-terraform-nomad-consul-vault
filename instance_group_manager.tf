resource "google_compute_region_instance_group_manager" "tncv" {
  name = "tncv-igm"
  base_instance_name = "tncv"
  instance_template  = "${google_compute_instance_template.tncv.self_link}"
  region             = "${var.region}"
}

resource "google_compute_region_autoscaler" "tncv" {
  name   = "tncv-autoscaler"
  target = "${google_compute_region_instance_group_manager.tncv.self_link}"

  autoscaling_policy {
    max_replicas    = 6
    min_replicas    = 3
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}
