resource "google_compute_instance_template" "satellite-vm-colombia-template" {
  name = "satellite-vm-colombia-template"

  // Specfiying the type of VM instance the template will create
  machine_type = var.machine_type
  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
  }

  // Assign the destination for VMs created by the template
  network_interface {
    network = google_compute_network.satellite-vpc.id
    access_config {}
  }

  tags = [var.allow-ingress-http]

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
    <img src="https://storage.googleapis.com/${google_storage_bucket.satellite-bucket.name}/Colombian.jpg" alt="Colombian prize!" style="max-width:600px; width:100%; display:block; margin:1rem 0;">
    <figcaption>Colombian dream!</figcaption>
  </figure>
</body>
</html>
EOF

cp /var/www/html/index.html /var/www/html/colombia
systemctl enable --now apache2
EOT
}

resource "google_compute_instance_template" "satellite-vm-thailand-template" {
  name = "satellite-vm-thailand-template"

  // Specfiying the type of VM instance the template will create
  machine_type = var.machine_type
  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
  }

  // Assign the destination for VMs created by the template
  network_interface {
    network = google_compute_network.satellite-vpc.id
    //  subnetwork = google_compute_subnetwork.satellite-sub.id
    access_config {}
  }

  tags = [var.allow-ingress-http]

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

cp /var/www/html/index.html /var/www/html/thailand
systemctl enable --now apache2
EOT
}