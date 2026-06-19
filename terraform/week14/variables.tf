variable "project" {
  description = "The GCP project your infrastructure will be deployed in"
  default     = "theowaf-class7-5-kevinwillocks"
}

variable "midwest_region" {
  default = "us-central1"
}

variable "south_region" {
  default = "us-south1"
}

variable "tunnel_secret01" {
  description = "Pre_shared secret for tunnel 1's connections"
  type        = string
  sensitive   = true
}

variable "tunnel_secret02" {
  description = "Pre_shared secret for tunnel 2's connections"
  type        = string
  sensitive   = true
}