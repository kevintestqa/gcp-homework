//Source: https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/automate-vpn-setup-with-terraform

resource "google_compute_ha_vpn_gateway" "domino-gateway" {
  name    = "domino-gateway"
  network = google_compute_network.domino-vpc.id //The network is the local VPC that owns the VPN gateway
  region  = var.midwest_region

}

resource "google_compute_ha_vpn_gateway" "satellite-gateway" {
  name    = "domino-gateway"
  network = google_compute_network.satellite-vpc.id //The network is the local VPC that owns the VPN gateway
  region  = var.south_region

}

//Source: https://docs.cloud.google.com/network-connectivity/docs/vpn/how-to/automate-vpn-setup-with-terraform
resource "google_compute_vpn_tunnel" "domino-to-satellite-tunnel01" {
  name                  = "domino-to-satellite-tunnel01"
  region                = var.midwest_region
  vpn_gateway           = google_compute_ha_vpn_gateway.domino-gateway.id    //gateway this resource belongs to
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.satellite-gateway.id //gateway this resource peers to.  Since both are GCP gateways, this needs to be used
  router                = google_compute_router.domino-router.id
  vpn_gateway_interface = 0
  shared_secret         = var.tunnel_secret01 //This is the pre-shared key
}

resource "google_compute_vpn_tunnel" "domino-to-satellite-tunnel02" {
  name                  = "domino-to-satellite-tunnel02"
  region                = var.midwest_region
  vpn_gateway           = google_compute_ha_vpn_gateway.domino-gateway.id    //gateway this resource belongs to
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.satellite-gateway.id //gateway this resource peers to.  Since both are GCP gateways, this needs to be used
  router                = google_compute_router.domino-router.id
  vpn_gateway_interface = 1
  shared_secret         = var.tunnel_secret02 //Make sure the tunnel secret matches the tunnel being used- the number convention is KEY
}

resource "google_compute_vpn_tunnel" "satellite-to-domino-tunnel01" {
  name                  = "satellite-to-domino-tunnel01"
  region                = var.south_region
  vpn_gateway           = google_compute_ha_vpn_gateway.satellite-gateway.id //gateway this resource belongs to
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.domino-gateway.id    //gateway this resource peers to.  Since both are GCP gateways, this needs to be used. Lines 40 and 41 need to be the reverse of the domino-tosatellite-tunnel resources
  router                = google_compute_router.satellite-router.id
  vpn_gateway_interface = 0
  shared_secret         = var.tunnel_secret01
}

resource "google_compute_vpn_tunnel" "satellite-to-domino-tunnel02" {
  name                  = "satellite-to-domino-tunnel02"
  region                = var.south_region
  vpn_gateway           = google_compute_ha_vpn_gateway.satellite-gateway.id //gateway this resource belongs to
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.domino-gateway.id    //gateway this resource peers to.  Since both are GCP gateways, this needs to be used. Lines 49 and 50 need to be the reverse of the domino-tosatellite-tunnel resources
  router                = google_compute_router.satellite-router.id
  vpn_gateway_interface = 1
  shared_secret         = var.tunnel_secret02
}