locals {
  colombia_Paths = ["/colombia", "/colombia/*"]
  thailand_Paths = ["/thailand", "/thailand/*"]
  alexandria_Paths = ["/alexandria", "/alexandria/*"]
  check_interval_sec_default = 60
  timeout_sec_default = 10
}

//Directs traffic based on the host_rule and path_matcher blocks
resource "google_compute_url_map" "satellitex23_urlmap" {
  name        = "satellitex23-ur-lmap"
  description = "Resource to route requests to specified backend services"

  default_service = google_compute_backend_bucket.satellitex23_image_backend.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "mysite"
  }

  path_matcher {
    name            = "mysite"
    default_service = google_compute_backend_bucket.satellitex23_image_backend.id

    path_rule {
      paths   = local.colombia_Paths
      service = google_compute_backend_service.satellitex23-colombia-fantasy.id
    }

    path_rule {
      paths   = local.thailand_Paths
      service = google_compute_backend_service.satellitex23-thailand-fantasy.id
    }

    path_rule {
      paths   = local.alexandria_Paths
      service = google_compute_backend_service.satellitex23-alexandria-fantasy.id
    }
  }

  //TODO: TRY TO EDIT THIS
  test {
    service = google_compute_backend_service.satellitex23-colombia-fantasy.id
    host    = "example.com"
    path    = "/colombia"
  }

  test {
    service = google_compute_backend_service.satellitex23-thailand-fantasy.id
    host    = "example.com"
    path    = "/thailand"
  }

  test {
    service = google_compute_backend_service.satellitex23-alexandria-fantasy.id
    host = "example.com"
    path = "/alexandria"
  }
}

//Tells load balancer WHERE to send traffic after the URL Map (traffic controller) chooses a backend
resource "google_compute_backend_service" "satellitex23-thailand-fantasy" {
  name                  = "thailand"
  port_name             = var.http_port_name
  protocol              = "HTTP"
  timeout_sec           = 600
  load_balancing_scheme = "EXTERNAL_MANAGED"

  health_checks = [google_compute_http_health_check.satellitex23-hc.id]

  backend {
    group = google_compute_region_instance_group_manager.satellitex23-thailand-mig.instance_group
  }

  depends_on = [google_compute_region_instance_group_manager.satellitex23-thailand-mig]

  lifecycle {
    create_before_destroy = true
  }
}

//Tells load balancer WHERE to send traffic after the URL Map (traffic controller) chooses a backend

resource "google_compute_backend_service" "satellitex23-colombia-fantasy" {
  name                  = "colombia"
  port_name             = var.http_port_name
  protocol              = "HTTP"
  timeout_sec           = 600
  load_balancing_scheme = "EXTERNAL_MANAGED"

  health_checks = [google_compute_http_health_check.satellitex23-hc.id]

  //TODO: Find out more. The backend needs to be attached https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service?utm_source=chatgpt.com#nested_backend
  backend {
    group = google_compute_region_instance_group_manager.satellitex23-colombia-mig.instance_group
  }

  depends_on = [google_compute_region_instance_group_manager.satellitex23-colombia-mig]

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_backend_service" "satellitex23-alexandria-fantasy" {
  name                  = "alexandria"
  port_name             = var.http_port_name
  protocol              = "HTTP"
  timeout_sec           = 600
  load_balancing_scheme = "EXTERNAL_MANAGED"

  health_checks = [google_compute_http_health_check.satellitex23-hc.id]

  //TODO: Find out more. The backend needs to be attached https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service?utm_source=chatgpt.com#nested_backend
  backend {
    group = google_compute_region_instance_group_manager.satellitex23-alexandria-mig.instance_group
  }

  depends_on = [google_compute_region_instance_group_manager.satellitex23-alexandria-mig]

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_http_health_check" "satellitex23-hc" {
  name               = "health-check"
  request_path       = "/"
  check_interval_sec = local.check_interval_sec_default
  timeout_sec        = local.timeout_sec_default
}


//Recieves http traffic from the forwarding rule and hands it off to the url map
//https://docs.cloud.google.com/cdn/docs/setting-up-cdn-with-bucket#terraform_1
resource "google_compute_target_http_proxy" "satellite_http_proxy" {
  name    = "http-lb-proxy"
  url_map = google_compute_url_map.satellitex23_urlmap.id
}

# forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "http-lb-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_target_http_proxy.satellite_http_proxy.id
}