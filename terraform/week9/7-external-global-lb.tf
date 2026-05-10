//For external LBs the following are required:  Use resource google_compute_url_map, google_compute_target_http_proxy, and google_compute_global_forwarding_rule for the frontend
//Use resource google_compute_backend_service for the backend. https://www.reddit.com/r/Terraform/comments/oe06w1/gcp_load_balancer_backend_service/ and https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map#argument-reference

resource "google_compute_url_map" "satellite_urlmap" {
  name        = "satellite_urlmap"
  description = "Resource to route reuests to specified backend services"

  default_service = google_compute_backend_bucket.satellite_image_backend.id

  # host_rule {
  #   hosts        = ["mysite.com"]
  #   path_matcher = "mysite"
  # }

  # host_rule {
  #   hosts        = ["myothersite.com"]
  #   path_matcher = "otherpaths"
  # }

  path_matcher {
    name            = "mysite"
    default_service = google_compute_backend_bucket.satellite_image_backend.id

    path_rule {
      paths   = ["/colombia"]
      service = google_compute_backend_service.satellite-colombia-fantasy.id
    }

    path_rule {
      paths   = ["/thailand"]
      service = google_compute_backend_service.satellite-thailand-fantasy.id
    }
  }

  //TODO: TRY TO EDIT THIS
  test {
    service = google_compute_backend_bucket.satellite_image_backend.id
    host    = "example.com"
    path    = "/colombia"
  }

  test {
    service = google_compute_backend_bucket.satellite_image_backend.id
    host    = "example.com"
    path    = "/thailand"
  }
}

resource "google_compute_backend_service" "satellite-thailand-fantasy" {
  name        = "thailand"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 60
  load_balancing_scheme = "EXTERNALMANAGED"

  health_checks = [google_compute_http_health_check.satellite-hc.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_backend_service" "satellite-colombia-fantasy" {
  name        = "colombia"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 60
  load_balancing_scheme = "EXTERNALMANAGED"

  health_checks = [google_compute_http_health_check.satellite-hc.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_http_health_check" "satellite-hc" {
  name               = "health-check"
  request_path       = "/"
  check_interval_sec = 20
  timeout_sec        = 5
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