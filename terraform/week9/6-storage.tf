resource "google_storage_bucket" "satellite-bucket" {
  name          = "satellite-bucket"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true
  public_access_prevention    = "inherited"
}

resource "google_storage_bucket_object" "satellite-colombia" {
  name         = "Colombian.jpg"
  source       = "${path.module}/assets/Colombian.jpg"
  bucket       = google_storage_bucket.satellite-bucket.name
  content_type = "image/jpeg"

  depends_on = [google_storage_bucket.satellite-bucket]
}

resource "google_storage_bucket_object" "satellite-thailand" {
  name         = "Thai.jpg"
  source       = "${path.module}/assets/Thai.jpg"
  bucket       = google_storage_bucket.satellite-bucket.name
  content_type = "image/jpeg"

  depends_on = [google_storage_bucket.satellite-bucket]
}

# make bucket public
resource "google_storage_bucket_iam_member" "satellite-bucket-access" {
  bucket = google_storage_bucket.satellite-bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_compute_backend_bucket" "satellite_image_backend" {
  name        = "fantasy-images"
  description = "Contains beautiful women"
  bucket_name = google_storage_bucket.satellite-bucket.name
  enable_cdn  = true
}
