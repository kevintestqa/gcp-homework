output "url_map_path_matcher" {
  value = google_compute_url_map.satellitex23_urlmap.path_matcher
}

output "colombia_backend_load_balancing_scheme" {
  value = "Colombia managed state is ${google_compute_backend_service.satellitex23-colombia-fantasy.load_balancing_scheme}"
}

output "thailand_backend_load_balancing_scheme" {
  value = "Thailand's managed state is ${google_compute_backend_service.satellitex23-thailand-fantasy.load_balancing_scheme}"
}

output "alexandria_backend_load_balancing_scheme" {
  value = "Alexandria's managed state is ${google_compute_backend_service.satellitex23-alexandria-fantasy.load_balancing_scheme}"
}

output "colombia_mig_creation_timestamp" {
  value = "Colombia MIG created at ${google_compute_region_instance_group_manager.satellitex23-colombia-mig.creation_timestamp}"
}

output "thailand_mig_creation_timestamp" {
  value = "Thailand MIG created at ${google_compute_region_instance_group_manager.satellitex23-thailand-mig.creation_timestamp}"
}