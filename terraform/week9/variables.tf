variable "project" {
  description = "The GCP project your infrastructure will be deployed in"
  default     = "theowaf-class7-5-kevinwillocks"
}

variable "machine_type" {
  description = "The default machine type for our instance group"
  default     = "n4-standard-2"
}

variable "allow-ingress-http" {
  description = "Target tags for allowing ingress http traffic"
  default     = "satellite-servers-ingress-http"
}