resource "google_compute_instance_template" "satellite-vm-colombia-template" {
  name = "satellite-vm-colombia-template"

  // Specfiying the type of VM instance the template will create
  machine_type = var.machine_type
  disk {
    source_image = "centos-cloud/centos-stream-10"
    auto_delete  = true
  }

  // Assign the destination for VMs created by the template
  network_interface {
    network = google_compute_network.satellite-vpc.id
    //  subnetwork = google_compute_subnetwork.satellite-sub.id
  }

  tags = [var.allow-ingress-http]

  metadata_startup_script = <<-EOT
    #!/bin/bash
META="http://metadata.google.internal/computeMetadata/v1/instance"
HEADER="Metadata-Flavor: Google"

# makes variables $NAME and $IP. Their values are from the curl command that hits the metadata service for VMs 
NAME=$(curl -H "$HEADER" "$META/name")
IP=$(curl -H "$HEADER" "$META/network-interfaces/0/ip")

# have the package manager grab the apache2 webserver 
dnf install -y httpd

# write our html file to the default location apache2 looks for
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<body>
  <h1>VM Metadata</h1>
  <h2>Instance Name: $NAME</h2>
  <h2>Internal IP: $IP</h2>
  <h2>Ven aqui</h2>
  <figure>
    <img src="https://storage.googleapis.com/satellite-bucket-qae01/Colombian.jpg" alt="Colombian prize!" style="max-width:600px; width:100%; display:block; margin:1rem 0;">
    <figcaption>Colombian dream!</figcaption>
  </figure>
</body>
</html>
EOF

# turn on apache2 service and make it turn on after the VM reboots too
systemctl enable --now httpd
EOT
}

resource "google_compute_instance_template" "satellite-vm-thailand-template" {
  name = "satellite-vm-thailand-template"

  // Specfiying the type of VM instance the template will create
  machine_type = var.machine_type
  disk {
    source_image = "centos-cloud/centos-stream-10"
    auto_delete  = true
  }

  // Assign the destination for VMs created by the template
  network_interface {
    network = google_compute_network.satellite-vpc.id
    //  subnetwork = google_compute_subnetwork.satellite-sub.id
  }

  tags = [var.allow-ingress-http]

  metadata_startup_script = <<-EOT
    #!/bin/bash
META="http://metadata.google.internal/computeMetadata/v1/instance"
HEADER="Metadata-Flavor: Google"

# makes variables $NAME and $IP. Their values are from the curl command that hits the metadata service for VMs 
NAME=$(curl -H "$HEADER" "$META/name")
IP=$(curl -H "$HEADER" "$META/network-interfaces/0/ip")

# have the package manager grab the apache2 webserver 
dnf install -y httpd

# write our html file to the default location apache2 looks for
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<body>
  <h1>VM Metadata</h1>
  <h2>Instance Name: $NAME</h2>
  <h2>Internal IP: $IP</h2>
  <h2>Ven aqui</h2>
  <figure>
    <img src="https://storage.googleapis.com/satellite-bucket-qae01/Thai.jpg" alt="Thai prize!  Just as good as Thai red curry!" style="max-width:600px; width:100%; display:block; margin:1rem 0;">
    <figcaption>Thai dream!</figcaption>
  </figure>
</body>
</html>
EOF

# turn on apache2 service and make it turn on after the VM reboots too
systemctl enable --now httpd
EOT
}