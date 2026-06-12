# Runbook

## Table of Contents

- [What are Classic and HA VPNs?](#what-is-classic-and-ha-vpn)
  - [How to set up Classic VPN](#how-to-set-up-classic-vpn)

## What is Classic and HA VPN?

- GCP offers two VPN options, Classic and HA VPNs. While HA VPNs are much better for redundancy, Classic VPNs are simpler in scope. For example, HA VPNs have built in IPv4 and IPv6 support. On the other hand, Classic VPN **only** offers IPv4 support. Classic VPNs use only 1 external IP address. In essence, GCP's VPN options are akin to secret tunnels to the White House. Classic VPNs only provide 1 tunnel. If that tunnel became unavailable, no one can use it. HA VPNs, on the other hand, have two tunnels. If one tunnel becomes unavailable, Secret Service can use the second.

**Source:**
- https://docs.cloud.google.com/network-connectivity/docs/vpn/concepts/overview#classic-vpn
- https://medium.com/@sadoksmine8/hybrid-connectivity-introduction-to-vpn-in-gcp-cd5f16833202

### How to set up Classic VPN

- Prerequisite - Team members must exchange planned IP addresses and ranges

**Source:** https://docs.cloud.google.com/monitoring/support/notification-options

1. Navigate to the VPN page in GCP
2. Click on **VPN setup wizard**
3. Select **Classic VPN** and click on **Continue**
4. Enter VPN gateway information
5. Click on **IP address**
6. Click on **Create IP address**
7. Enter static IP address information and click on **Reserve**
8. Under the **Tunnels** section edit the name to the required convention
9. Under **Remote peer IP address** enter team member's IP address
10. In the **IKE pre-shared key** field, click on **Generate**. Make sure to save it for future reference
11. In the **Remote network IP ranges** field, enter the team member's IP range
12. Click on **Create**
13. Click on the created VPN
14. Ensure that the Forwarding rules section contains esp, udp:4500, udp:500 protocols
15. (Optional) If needed add a VPN tunnel