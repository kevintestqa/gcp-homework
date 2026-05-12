resource "google_compute_region_instance_group_manager" "satellite-colombia-mig" {
  base_instance_name = "satellite-colombia-mi"
  name               = "satellite-colombia-mi"
  region             = "us-west1"
  target_size        = 2

  //Grabs the instance template url
  version {
    instance_template = google_compute_instance_template.satellite-vm-colombia-template.self_link
  }

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_http_health_check.satellite-hc.id
    initial_delay_sec = 500
  }
}

resource "google_compute_region_instance_group_manager" "satellite-thailand-mig" {
  base_instance_name = "satellite-thailand-mi"
  name               = "satellite-thailand-mi"
  region             = "us-west1"
  target_size        = 2

  //Grabs the instance template url
  version {
    instance_template = google_compute_instance_template.satellite-vm-thailand-template.self_link
  }
  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_http_health_check.satellite-hc.id
    initial_delay_sec = 500
  }
}