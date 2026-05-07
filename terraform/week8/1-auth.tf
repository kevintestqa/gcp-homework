terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "theowaf-class7-5-kevinwillocks" //Ensure the correct project is entered here!!!
  region  = "us-west-1"
}