resource "google_storage_bucket_iam_member" "hyrule-static-site-member" {
  bucket = google_storage_bucket.hyrule-static-site.name
  role = "roles/storage.objectViewer"
  member = "allUsers"
}