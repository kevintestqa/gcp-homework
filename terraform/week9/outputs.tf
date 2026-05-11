output "url_map_path_matcher" {
  value = google_compute_url_map.satellite_urlmap.path_matcher
}

output "colombia_backend" {
  value = google_compute_backend_service.satellite-colombia-fantasy.self_link
}

output "thailand_backend" {
  value = google_compute_backend_service.satellite-thailand-fantasy.self_link
}

output "colombia_mig" {
  value = google_compute_region_instance_group_manager.satellite-colombia-mig.description
}

output "thailand_mig" {
  value = google_compute_region_instance_group_manager.satellite-thailand-mig.description
}