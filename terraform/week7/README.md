# Week 7 GCS project guide

The GCs project simply creates the following resources in the project : **theowaf-class7-5-kevinwillocks**
## Resources
* A VPC named **hyrule**
* A local file named **favorite-food**
* A variable named project
##

## Resource roles and responsibilities
* **hyrule** is the responsibile for hosting the infrastruture as part of the project: **theowaf-class7-5-kevinwillocks**
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

* **favorite-food** creates a text file that specifies a favorite Panamaian dish.
Please refer to the following:

```
resource "local_file" "favorite-food" {
  content  = "lentils, rice and chicken!  Very Panamanian"
  filename = "${path.module}/favoritefood.txt"
}
```
* The **content** argument is responsible for displaying the content of the created file.
* **Filename** takes a path in our project, and creates a file in that path.  You decide the name and the type of file (extension) it will be.


| Resource      | Source         |
| ------------- |:-------------:|
| Local_file resource information  | https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file   |
| Google Compute Network resource information      | https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network   |
| Variable resource information      | https://developer.hashicorp.com/terraform/language/values/variables     |
| Output resource information | https://developer.hashicorp.com/terraform/language/values/outputs|