//For external LBs the following are required:  Use resource google_compute_url_map, google_compute_target_http_proxy, and google_compute_global_forwarding_rule for the frontend
//Use resource google_compute_backend_service for the backend. https://www.reddit.com/r/Terraform/comments/oe06w1/gcp_load_balancer_backend_service/ and https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map#argument-reference

resource "google_compute_url_map" "satellite_urlmap" {
  name        = "satellite-ur-lmap"
  description = "Resource to route reuests to specified backend services"

  default_service = google_compute_backend_bucket.satellite_image_backend.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "mysite"
  }

  path_matcher {
    name            = "mysite"
    default_service = google_compute_backend_bucket.satellite_image_backend.id

    path_rule {
      paths   = ["/colombia", "/colombia/*"]
      service = google_compute_backend_service.satellite-colombia-fantasy.id
    }

    path_rule {
      paths   = ["/thailand", "/thailand/*"]
      service = google_compute_backend_service.satellite-thailand-fantasy.id
    }
  }

  //TODO: TRY TO EDIT THIS
  test {
    service = google_compute_backend_service.satellite-colombia-fantasy.id
    host    = "example.com"
    path    = "/colombia"
  }

  test {
    service = google_compute_backend_service.satellite-thailand-fantasy.id
    host    = "example.com"
    path    = "/thailand"
  }
}

resource "google_compute_backend_service" "satellite-thailand-fantasy" {
  name                  = "thailand"
  port_name             = "http"
  protocol              = "HTTP"
  timeout_sec           = 60
  load_balancing_scheme = "EXTERNAL_MANAGED"

  health_checks = [google_compute_http_health_check.satellite-hc.id]

  backend {
    group = google_compute_region_instance_group_manager.satellite-thailand-mig.instance_group
  }

  depends_on = [google_compute_region_instance_group_manager.satellite-thailand-mig]

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_backend_service" "satellite-colombia-fantasy" {
  name                  = "colombia"
  port_name             = "http"
  protocol              = "HTTP"
  timeout_sec           = 60
  load_balancing_scheme = "EXTERNAL_MANAGED"

  health_checks = [google_compute_http_health_check.satellite-hc.id]

  //TODO: Find out more. The backend needs to be attached https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service?utm_source=chatgpt.com#nested_backend
  backend {
    group = google_compute_region_instance_group_manager.satellite-colombia-mig.instance_group
  }

  depends_on = [google_compute_region_instance_group_manager.satellite-colombia-mig]

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_http_health_check" "satellite-hc" {
  name               = "health-check"
  request_path       = "/"
  check_interval_sec = 60
  timeout_sec        = 10
}


//https://docs.cloud.google.com/cdn/docs/setting-up-cdn-with-bucket#terraform_1
resource "google_compute_target_http_proxy" "satellite_http_proxy" {
  name    = "http-lb-proxy"
  url_map = google_compute_url_map.satellite_urlmap.id
}

# forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "http-lb-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_target_http_proxy.satellite_http_proxy.id
}