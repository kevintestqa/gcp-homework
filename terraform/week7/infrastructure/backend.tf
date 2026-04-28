terraform {
  backend "gcs" {
    bucket = "hyrule-storage"
    prefix = "static/assets"
  }
}


resource "google_compute_disk" "grafana_disk" {
  #depends_on = [terraform_data.preflight_gate]
  name  = "grafana-disk"
  type  = "pd-standard"
  zone  = "us-central1-a"
  size  = 10
}