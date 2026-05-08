resource "google_compute_network" "satellite-2x" {
  project                 = "theowaf-class7-5-kevinwillocks"
  name                    = "satellite-2x"
  auto_create_subnetworks = true
  mtu                     = 1460
}

resource "google_compute_subnetwork" "satellite-sub" {
  name                     = "satellite-sub"
  ip_cidr_range            = "10.20.0.0/18"
  region                   = "us-west1"
  network                  = google_compute_network.satellite-2x.id
  private_ip_google_access = false

  # IMPORTANT:
  # These CIDR ranges MUST NOT overlap
  # Do not modify unless you understand subnetting

  secondary_ip_range {
    range_name    = "satellite-sub-alpha-range"
    ip_cidr_range = "10.48.0.0/14"
  }

  secondary_ip_range {
    range_name    = "satellite-sub-beta-range"
    ip_cidr_range = "10.52.0.0/20"
  }

  depends_on = [
    google_compute_network.satellite-2x
  ]
}