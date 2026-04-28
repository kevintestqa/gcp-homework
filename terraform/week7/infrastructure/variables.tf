variable "project" {
    description = "The GCP project your infrastructure will be deployed in"
    default = "theowaf-class7-5-kevinwillocks"
}

variable "bucket" {
    description = "Name of the bucket"
    default = "hyrule-storage"
}

variable "neo-bucket" {
    description = "Name of the bucket"
    default = "neo-hyrule-storage"
}