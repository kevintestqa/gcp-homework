// The google_compute_instance_template is the resource needed to create an instance template in GCP.  Teams will be able to create Managed Instance groups using this template.  Visit https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template for more information
resource "google_compute_instance_template" "satellite-2x-vm-template" {
    name = "satellite-2x-vm-template"

// Specfiying the type of VM instance the template will create
  machine_type = google_compute_instance.satellite-2x-vm01.machine_type
  disk {
    source_image = "centos-cloud/centos-stream-10"
    auto_delete = true
    disk_type = "value"
  }

// Assign the destination for VMs created by the template
  network_interface {
    network    = google_compute_network.satellite-2x.id
    subnetwork = google_compute_subnetwork.satellite-sub.id
  }

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
  <h2>Colombian prize included for free!</h2>
  <figure>
    <img src="https://test-1256099743.s3.us-east-2.amazonaws.com/Colombian/imgi_22_551283556_24677511425231259_7293143846320648055_n.jpg" alt="Colombian prize!" style="max-width:600px; width:100%; display:block; margin:1rem 0;">
    <figcaption>Colombian prize!</figcaption>
  </figure>
</body>
</html>
EOF

# turn on apache2 service and make it turn on after the VM reboots too
systemctl enable --now httpd
EOT
}