resource "google_compute_network" "satellitex23-vpc" {
  project                 = var.project
  name                    = "satellite-x23vpc"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "satellite-sub" {
  name                     = "satellite-sub"
  ip_cidr_range            = "10.30.0.0/18"
  region                   = var.region
  network                  = google_compute_network.satellitex23-vpc.id
  private_ip_google_access = false

  secondary_ip_range {
    range_name    = "satellite-sub-alpha-range"
    ip_cidr_range = "10.32.0.0/14"
  }

  secondary_ip_range {
    range_name    = "satellite-sub-beta-range"
    ip_cidr_range = "10.31.0.0/20"
  }

  depends_on = [
    google_compute_network.satellitex23-vpc
  ]
}