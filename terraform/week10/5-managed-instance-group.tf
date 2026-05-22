resource "google_compute_region_instance_group_manager" "satellitex23-colombia-mig" {
  base_instance_name = "satellitex23-colombia-mi"
  name               = "satellitex23-colombia-mi"
  region             = var.region
  target_size        = 2

  //Grabs the instance template url
  version {
    instance_template = google_compute_instance_template.satellitex23-vm-colombia-template.self_link
  }

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_http_health_check.satellitex23-hc.id
    initial_delay_sec = var.initial_delay_sec
  }
}

resource "google_compute_region_instance_group_manager" "satellitex23-thailand-mig" {
  base_instance_name = "satellitex23-thailand-mi"
  name               = "satellitex23-thailand-mi"
  region             = var.region
  target_size        = 2

  //Grabs the instance template url
  version {
    instance_template = google_compute_instance_template.satellitex23-vm-thailand-template.self_link
  }
  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_http_health_check.satellitex23-hc.id
    initial_delay_sec = var.initial_delay_sec
  }
}

resource "google_compute_region_instance_group_manager" "satellitex23-alexandria-mig" {
  base_instance_name = "satellitex23-alexandria-mi"
  name               = "satellitex23-alexandria-mi"
  region             = var.region
  target_size        = 2

  //Grabs the instance template url
  version {
    instance_template = google_compute_instance_template.satellitex23-vm-alexandria-template.self_link
  }
  named_port {
    name = var.http_port_name
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_http_health_check.satellitex23-hc.id
    initial_delay_sec = var.initial_delay_sec
  }
}