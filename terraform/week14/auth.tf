terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.37"
    }
  }
}

provider "google" {
  project = "theowaf-class7-5-kevinwillocks" //Ensure the correct project is entered here!!!
  region  = var.midwest_region
}