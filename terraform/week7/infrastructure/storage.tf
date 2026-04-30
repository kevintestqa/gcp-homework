resource "google_storage_bucket" "hyrule-static-site" {
  name          = var.neo-bucket
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true
  public_access_prevention = "inherited"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

//Uploads 404.html, index.html and style.css files to the desired bucket
resource "google_storage_bucket_object" "hyrule-error-html" {
  name   = "error.html"
  source = "${path.module}/static-site-asset/404.html"
  bucket = var.neo-bucket

  depends_on = [ google_storage_bucket.hyrule-static-site ]
}

resource "google_storage_bucket_object" "hyrule-index-html" {
  name   = "index.html"
  source = "${path.module}/static-site-asset/index.html"
  bucket = var.neo-bucket

   depends_on = [ google_storage_bucket.hyrule-static-site ]
}

resource "google_storage_bucket_object" "hyrule-css" {
  name   = "style.css"
  source = "${path.module}/static-site-asset/style.css"
  bucket = var.neo-bucket

   depends_on = [ google_storage_bucket.hyrule-static-site ]
}

resource "google_storage_bucket_object" "hyrule-porshe" {
  name   = "porshe.jpeg" //images apprently need the extenstion 
  source = "${path.module}/static-site-asset/porshe.jpeg"
  bucket = var.neo-bucket
  content_type = "image/jpeg"

   depends_on = [ google_storage_bucket.hyrule-static-site ]
}