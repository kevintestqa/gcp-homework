resource "google_compute_network" "domino-vpc" {
  project                 = var.project
  name                    = "domino-vpc"
  auto_create_subnetworks = false
  mtu                     = 1460
  routing_mode            = "GLOBAL"

}

resource "google_compute_subnetwork" "domino-sub" {
  name                     = "domino-sub"
  ip_cidr_range            = "10.30.0.0/18"
  region                   = var.midwest_region
  network                  = google_compute_network.domino-vpc.id
  private_ip_google_access = false

  secondary_ip_range {
    range_name    = "domino-sub-alpha-range"
    ip_cidr_range = "10.32.0.0/14"
  }

  secondary_ip_range {
    range_name    = "domino-sub-beta-range"
    ip_cidr_range = "10.31.0.0/20"
  }

  depends_on = [
    google_compute_network.domino-vpc
  ]
}

//Second VPC

resource "google_compute_network" "satellite-vpc" {
  project                 = var.project
  name                    = "satellite-vpc"
  auto_create_subnetworks = false
  mtu                     = 1460
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "satellite-sub" {
  name                     = "satellite-sub"
  ip_cidr_range            = "10.50.0.0/18"
  region                   = var.south_region
  network                  = google_compute_network.satellite-vpc.id
  private_ip_google_access = false

  secondary_ip_range {
    range_name    = "satellite-sub-alpha-range"
    ip_cidr_range = "10.52.0.0/14"
  }

  secondary_ip_range {
    range_name    = "satellite-sub-beta-range"
    ip_cidr_range = "10.51.0.0/20"
  }

  depends_on = [
    google_compute_network.satellite-vpc
  ]
}