resource "google_compute_firewall" "satellite-allow-http" {
  name    = "satellite-allow-http"
  network = google_compute_network.satellitex23-vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]

  depends_on = [
    google_compute_network.satellitex23-vpc
  ]

  target_tags = [var.allow-ingress-http]
}