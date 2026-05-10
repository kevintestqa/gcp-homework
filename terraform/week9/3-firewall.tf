resource "google_compute_firewall" "satellite_allow_http" {
  name    = "satellite_allow_http"
  network = google_compute_network.satellite-vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]

  depends_on = [
    google_compute_network.satellite-vpc
  ]

  target_tags = [var.allow-ingress-http]
}