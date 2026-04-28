output "vm_name" {
  description = "Name of the VPC"
  value       = google_compute_network.hyrule.name
}

output "index_url" {
  value = "https://storage.googleapis.com/${google_storage_bucket.hyrule-static-site.name}/${google_storage_bucket_object.hyrule-index-html.name}"
}

output "error_url" {
  value = "https://storage.googleapis.com/${google_storage_bucket.hyrule-static-site.name}/${google_storage_bucket_object.hyrule-error-html.name}"
}

output "porshe_url" {
  value = "https://storage.googleapis.com/${google_storage_bucket.hyrule-static-site.name}/${google_storage_bucket_object.hyrule-porshe.name}"
}