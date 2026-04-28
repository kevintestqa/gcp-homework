resource "google_compute_network" "hyrule" {
  project                 = var.project
  name                    = "hyrule"
  auto_create_subnetworks = true
  mtu                     = 1460
}