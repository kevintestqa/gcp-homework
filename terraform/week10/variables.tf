variable "project" {
  description = "The GCP project your infrastructure will be deployed in"
  default     = "theowaf-class7-5-kevinwillocks"
}

variable "machine_type" {
  description = "The default machine type for our instance group"
  default     = "e2-medium"
}

variable "allow-ingress-http" {
  description = "Target tags for allowing ingress http traffic"
  default     = "satellite-servers-ingress-http"
}

variable "http_port_name" {
  default = "http"
}