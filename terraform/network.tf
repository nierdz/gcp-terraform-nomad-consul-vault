resource "google_compute_network" "tncv_network" {
  name = "tncv-network"
}

### Firewall rules
# ICMP
resource "google_compute_firewall" "tncv_icmp" {
  name    = "tncv-icmp"
  network = google_compute_network.tncv_network.self_link

  allow {
    protocol = "icmp"
  }

}

# SSH
resource "google_compute_firewall" "tncv_ssh" {
  name    = "tncv-ssh"
  network = google_compute_network.tncv_network.self_link

  allow {
    protocol           = "tcp"
    ports              = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]

}

# Consul TCP ports
resource "google_compute_firewall" "tncv_consul_tcp" {
  name    = "tncv-consul-tcp"
  network = google_compute_network.tncv_network.self_link

  allow {
    protocol           = "tcp"
    ports              = ["8300", "8301", "8302", "8500", "8600"]
  }

  source_tags = ["consul-server"]
  target_tags = ["consul-server"]

}

# Consul TCP ports
resource "google_compute_firewall" "tncv_consul_udp" {
  name    = "tncv-consul-udp"
  network = google_compute_network.tncv_network.self_link

  allow {
    protocol           = "udp"
    ports              = ["8301", "8302", "8600"]
  }

  source_tags = ["consul-server"]
  target_tags = ["consul-server"]

}

# Consul HTTP port
resource "google_compute_firewall" "tncv_consul_http" {
  name    = "tncv-consul-http"
  network = google_compute_network.tncv_network.self_link

  allow {
    protocol           = "tcp"
    ports              = ["8500"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["consul-server"]

}
