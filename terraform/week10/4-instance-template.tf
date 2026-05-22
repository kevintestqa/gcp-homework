resource "google_compute_instance_template" "satellitex23-vm-colombia-template" {
  name = "satellite-vm-colombia-template"

  // Specfiying the type of VM instance the template will create
  machine_type = var.machine_type
  disk {
    source_image = var.source_image
    auto_delete  = true
  }

  // Assign the destination for VMs created by the template
  network_interface {
    subnetwork = google_compute_subnetwork.satellite-sub.id
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
    <img src="https://storage.googleapis.com/${google_storage_bucket.satellitex23-bucket.name}/colombianmodel.jpg" alt="Hola Mami" style="max-width:600px; width:100%; display:block; margin:1rem 0;">
    <figcaption>Pon tu culo bonita en mi cama</figcaption>
  </figure>
</body>
</html>
EOF

cp /var/www/html/index.html /var/www/html/colombia
systemctl enable --now apache2
EOT
}

resource "google_compute_instance_template" "satellitex23-vm-thailand-template" {
  name = "satellite-vm-thailand-template"

  // Specfiying the type of VM instance the template will create
  machine_type = var.machine_type
  disk {
    source_image = var.source_image
    auto_delete  = true
  }

  // Assign the destination for VMs created by the template
  network_interface {
    subnetwork = google_compute_subnetwork.satellite-sub.id
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
    <img src="https://storage.googleapis.com/${google_storage_bucket.satellitex23-bucket.name}/thaimodel.jpg" alt="Welcome!" style="max-width:600px; width:100%; display:block; margin:1rem 0;">
    <figcaption> Brb, busy with this model </figcaption>
  </figure>
</body>
</html>
EOF

cp /var/www/html/index.html /var/www/html/thailand
systemctl enable --now apache2
EOT
}

resource "google_compute_instance_template" "satellitex23-vm-alexandria-template" {
  name = "satellite-vm-alexandria-template"

  // Specfiying the type of VM instance the template will create
  machine_type = var.machine_type
  disk {
    source_image = var.source_image
    auto_delete  = true
  }

  // Assign the destination for VMs created by the template
  network_interface {
    subnetwork = google_compute_subnetwork.satellite-sub.id
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
  <h2>Honey I am home!</h2>
  <figure>
    <img src="https://storage.googleapis.com/${google_storage_bucket.satellitex23-bucket.name}/queenbrahne.jpg" alt="You come home to this after getting your comptia cert!" style="max-width:600px; width:100%; display:block; margin:1rem 0;">
    <figcaption> Lay in bed with her and think about your life </figcaption>
  </figure>
</body>
</html>
EOF

cp /var/www/html/index.html /var/www/html/alexandria
systemctl enable --now apache2
EOT
}