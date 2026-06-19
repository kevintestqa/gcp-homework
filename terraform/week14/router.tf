//Source: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router
//Routers are responsible for establishing BGP sessions

resource "google_compute_router" "domino-router" {
  name    = "domino-router"
  region  = var.midwest_region
  network = google_compute_network.domino-vpc.name
  bgp {
    asn = 65505
  }
}


resource "google_compute_router" "satellite-router" {
  name    = "satellite-router"
  region  = var.south_region
  network = google_compute_network.satellite-vpc.name
  bgp {
    asn = 65506
  }
}

//Source: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_interface & https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/automate-vpn-setup-with-terraform
resource "google_compute_router_interface" "domino-router-interface01" {
  name       = "domino-router-interface01"
  router     = google_compute_router.domino-router.name
  region     = var.midwest_region
  ip_range   = "169.254.0.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.domino-to-satellite-tunnel01.name
}

resource "google_compute_router_peer" "domino-peer01" {
  name            = "domino-peer01"
  router          = google_compute_router.domino-router.name
  region          = var.midwest_region
  interface       = google_compute_router_interface.domino-router-interface01.name
  peer_ip_address = "169.254.0.2"
  peer_asn        = 65506 //Needs to be the asn of the opposite router - in this case satellite
}

resource "google_compute_router_interface" "domino-router-interface02" {
  name       = "domino-router-interface02"
  router     = google_compute_router.domino-router.name
  region     = var.midwest_region
  ip_range   = "169.254.1.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.domino-to-satellite-tunnel02.name //Make sure the vpn tunnel is updated for each interface
}

resource "google_compute_router_peer" "domino-peer02" {
  name            = "domino-peer02"
  router          = google_compute_router.domino-router.name
  region          = var.midwest_region
  interface       = google_compute_router_interface.domino-router-interface02.name
  peer_ip_address = "169.254.1.2"
  peer_asn        = 65506 //Needs to be the asn of the opposite router - in this case satellite
}

resource "google_compute_router_interface" "satellite-router-interface01" {
  name       = "satellite-router-interface01"
  router     = google_compute_router.satellite-router.name
  region     = var.south_region
  ip_range   = "169.254.0.2/30"
  vpn_tunnel = google_compute_vpn_tunnel.satellite-to-domino-tunnel01.name
}

resource "google_compute_router_peer" "satellite-peer01" {
  name            = "satellite-peer01"
  router          = google_compute_router.satellite-router.name
  region          = var.south_region
  interface       = google_compute_router_interface.satellite-router-interface01.name
  peer_ip_address = "169.254.0.1"
  peer_asn        = 65505 //Needs to be the asn of the opposite router - in this case domino
}

resource "google_compute_router_interface" "satellite-router-interface02" {
  name       = "satellite-router-interface02"
  router     = google_compute_router.satellite-router.name
  region     = var.south_region
  ip_range   = "169.254.1.2/30"
  vpn_tunnel = google_compute_vpn_tunnel.satellite-to-domino-tunnel02.name
}

resource "google_compute_router_peer" "satellite-peer02" {
  name            = "satellite-peer02"
  router          = google_compute_router.satellite-router.name
  region          = var.south_region
  interface       = google_compute_router_interface.satellite-router-interface02.name
  peer_ip_address = "169.254.1.1"
  peer_asn        = 65505 //Needs to be the asn of the opposite router - in this case domino
}