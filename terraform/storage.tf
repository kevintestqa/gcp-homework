# THIS DOES NOT WORK. I ALREADY HAVE THE BUCKET 
#resource "google_storage_bucket" "hyrule-static-site" {
#   name          = "hyrule-storage"
#   location      = "US"
#   force_destroy = true

#   uniform_bucket_level_access = true

#   website {
#     main_page_suffix = "index.html"
#     not_found_page   = "404.html"
#   }
# }

resource "google_storage_bucket_object" "hyrule-error-html" {
  name   = "error"
  source = "${path.module}/404.html"
  bucket = "hyrule-storage"
}

resource "google_storage_bucket_object" "hyrule-index-html" {
  name   = "index"
  source = "${path.module}/index.html"
  bucket = "hyrule-storage"
}

resource "google_storage_bucket_object" "hyrule-css" {
  name   = "style"
  source = "${path.module}/style.cssl"
  bucket = "hyrule-storage"
}