resource "google_storage_bucket" "satellitex23-bucket" {
  name          = "satellitex23-bucket-willocks"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true
  public_access_prevention    = "inherited"
}

resource "google_storage_bucket_object" "satellitex23-colombia" {
  name         = "colombianmodel.jpg"
  source       = "${path.module}/Assets/colombianmodel.jpg"
  bucket       = google_storage_bucket.satellitex23-bucket.name
  content_type = "image/jpeg"

  depends_on = [google_storage_bucket.satellitex23-bucket]
}

resource "google_storage_bucket_object" "satellitex23-thailand" {
  name         = "thaimodel.jpg"
  source       = "${path.module}/Assets/thaimodel.jpg"
  bucket       = google_storage_bucket.satellitex23-bucket.name
  content_type = "image/jpeg"

  depends_on = [google_storage_bucket.satellitex23-bucket]
}

resource "google_storage_bucket_object" "satellitex23-alexandria" {
  name         = "queenbrahne.jpg"
  source       = "${path.module}/Assets/queenbrahne.jpg"
  bucket       = google_storage_bucket.satellitex23-bucket.name
  content_type = "image/jpeg"

  depends_on = [google_storage_bucket.satellitex23-bucket]
}

# make bucket public
resource "google_storage_bucket_iam_member" "satellitex23-bucket-access" {
  bucket = google_storage_bucket.satellitex23-bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_compute_backend_bucket" "satellitex23_image_backend" {
  name        = "fantasy-women"
  description = "Contains beautiful women"
  bucket_name = google_storage_bucket.satellitex23-bucket.name
  enable_cdn  = true
}
