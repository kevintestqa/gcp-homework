output "interal_ip" {
  value = google_compute_instance.satellite-2x-vm01.network_interface.0.network_ip
}

output "external_ip" {
  value = google_compute_instance.satellite-2x-vm01.network_interface[0].access_config[0].nat_ip
}

output "name" {
  value = google_compute_instance.satellite-2x-vm01.name
}

output "id" {
  value = google_compute_instance.satellite-2x-vm01.id
}

output "self_link" {
  value = google_compute_instance.satellite-2x-vm01.self_link
}

output "ip_addresses" {
    // This is done by string concatenation - combining values from internal, external IPs and a custom sentence
  value = "The internal ip address is ${google_compute_instance.satellite-2x-vm01.network_interface.0.network_ip} and the external ip address is ${google_compute_instance.satellite-2x-vm01.network_interface[0].access_config[0].nat_ip}"
}