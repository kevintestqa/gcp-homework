# Week 7 GCS project guide

The GCs project simply creates the following resources in the project : **theowaf-class7-5-kevinwillocks**
## Resources
* A VPC named **hyrule**
* A local file named **favorite-food**
* A variable named project
* A GCP bucket containing assets for a static site


| Resource      | Source         |
| ------------- |:-------------:|
| Error state  | https://storage.googleapis.com/neo-hyrule-storage/error.html   |
| Working state | https://storage.googleapis.com/neo-hyrule-storage/index.html   |
| Porshe image | https://storage.googleapis.com/neo-hyrule-storage/porshe.jpeg     |

* IAM member that allows the static site inside the bucket to be accessed by anyone
##

## Resource roles and responsibilities
* **Hyrule** is the responsibile for hosting the infrastruture as part of the project: **theowaf-class7-5-kevinwillocks**
* The variable named "project" passes **theowaf-class7-5-kevinwillocks** declared as **default** to the provider's **project** argument, making neccesary updates easier.  
**Please refer to the following:**
```
variable "project" {
    description = "The GCP project your infrastructure will be deployed in"
    default = "theowaf-class7-5-kevinwillocks"
}
```
```
provider "google" {
  project = var.project //Ensure the correct project is entered here!!!
  region  = "us-central1"
}
```

* **favorite-food** creates a text file (**favoritefood.txt) that specifies a favorite Panamaian dish.
Please refer to the following:

```
resource "local_file" "favorite-food" {
  content  = "Lentils, rice and chicken!  Very Panamanian"
  filename = "${path.module}/favoritefood.txt"
}
```
* The **content** argument is responsible for displaying the content of the created file.
* **Filename** takes a path in our project, and creates a file in that path.  You decide the name and the type of file (extension) it will be.
* The project also creates a bucket named **hyrule-static-site** that hosts 2 html files, a jpeg and css file
* Each file is denoted by google_storage_bucket_object and is uploaded to **hyrule-static-site**

**Please refer to the following:**
```
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
```


| Resource      | Source         |
| ------------- |:-------------:|
| Local_file resource information  | https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file   |
| Google Compute Network resource information      | https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network   |
| Variable resource information      | https://developer.hashicorp.com/terraform/language/values/variables     |
| Output resource information | https://developer.hashicorp.com/terraform/language/values/outputs|
| IAM Member information | https://registry.terraform.io/providers/wiardvanrij/ipv4google/latest/docs/resources/storage_bucket_iam|
|Google Storage bucket information| https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket|
|Google storage bucket object information| https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object|
