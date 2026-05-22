variable "project" {
  description = "The GCP project your infrastructure will be deployed in"
  default     = "theowaf-class7-5-kevinwillocks"
}

variable "region" {
  type = string
  description = "The GCP region to deploy resources into"
}
variable "machine_type" {
  description = "The default machine type for our instance group"
  default     = "e2-medium"
}

variable "source_image" {
  type = string
  description = "Image used for instance templates"
}

variable "initial_delay_sec" {
  type = number
  description = "Default value to determine how long  MIG will have to wait before starting autohealing"
}

variable "timeout_sec" {
  type = number
  description = "Request timeout for http(s) traffic for external ALB"
}

variable "allow-ingress-http" {
  description = "Target tags for allowing ingress http traffic"
  default     = "satellite-servers-ingress-http"
}

variable "http_port_name" {
  default = "http"
}