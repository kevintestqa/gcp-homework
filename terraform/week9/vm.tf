resource "google_compute_instance" "satellite-2x-vm01" {
  name         = "satellite-2x-vm01"
  machine_type = "e2-medium"
  zone         = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 100
    }
  }

  network_interface {
    network = google_compute_network.satellite-vpc.id

    access_config {}
  }

  metadata_startup_script = <<-EOT
#!/bin/bash
set -euxo pipefail

META="http://metadata.google.internal/computeMetadata/v1/instance"
HEADER="Metadata-Flavor: Google"

NAME="$(curl -sf -H "$HEADER" "$META/name")"
IP="$(curl -sf -H "$HEADER" "$META/network-interfaces/0/ip")"

apt-get update
apt-get install -y apache2

cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<body>
  <h1>VM Metadata</h1>
  <h2>Instance Name: $NAME</h2>
  <h2>Internal IP: $IP</h2>
  <h2>Ven aqui</h2>
  <figure>
    <img src="https://storage.googleapis.com/${google_storage_bucket.satellite-bucket.name}/Thai.jpg" alt="Thai prize! Just as good as Thai red curry!" style="max-width:600px; width:100%; display:block; margin:1rem 0;">
    <figcaption>Thai dream!</figcaption>
  </figure>
</body>
</html>
EOF

systemctl enable --now apache2
EOT

  tags = [var.allow-ingress-http]
}