resource "google_compute_network" "satellite-vpc" {
  project                 = var.project
  name                    = "satellite-vpc"
  auto_create_subnetworks = true
  mtu                     = 1460
}

# resource "google_compute_subnetwork" "satellite-sub" {
#   name                     = "satellite-sub"
#   ip_cidr_range            = "10.30.0.0/18"
#   region                   = "us-west1"
#   network                  = google_compute_network.satellite-vpc.id
#   private_ip_google_access = false

#   secondary_ip_range {
#     range_name    = "satellite-sub-alpha-range"
#     ip_cidr_range = "10.50.0.0/14"
#   }

#   secondary_ip_range {
#     range_name    = "satellite-sub-beta-range"
#     ip_cidr_range = "10.60.0.0/20"
#   }

#   depends_on = [
#     google_compute_network.satellite-vpc
#   ]
# }