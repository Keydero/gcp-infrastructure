
resource "google_compute_network" "network" {
  project                 = var.project
  name                    = "dataflow-demo"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "data-subnet" {
  name          = "data-subnet"
  ip_cidr_range = "172.168.0.0/16"
  region        = "europe-west1"
  network       = google_compute_network.network.name
  private_ip_google_access = true
}

resource "google_compute_firewall" "dataflow_allow_internal_connection" {
  name    = "allow-df-internal-connection"
  network = google_compute_network.network.name

  allow {
    protocol = "tcp"
    ports    = [ "0-65535"]
  }

  source_tags = ["dataflow"]
}