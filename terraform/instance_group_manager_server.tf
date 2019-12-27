resource "google_compute_region_instance_group_manager" "server-igm" {
  name               = "server-igm"
  base_instance_name = "server"
  region             = var.region

  version {
    instance_template = google_compute_instance_template.server-it.self_link
  }
}

resource "google_compute_region_autoscaler" "server-autoscaler" {
  name   = "server-autoscaler"
  target = google_compute_region_instance_group_manager.server-igm.self_link

  autoscaling_policy {
    max_replicas    = 6
    min_replicas    = 3
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}
