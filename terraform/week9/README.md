# Q & A
## Load Balancers
* Load balancing contributes to Fault Tolerance by protecting against a single point of failure in an environment. Load balancers also maintain high availabilty by ensuring web servers continue to recieve traffic by monitoring the instance health via health checks.  LBs are needed if the goal is to minimize downtime to ensure clients are able to use a company's services.  LBs are different from a reverse proxy in the sense that reverse proxys returns server responses to clients while LBs ensure that the the right client recieves the appropriate response. https://www.cloudflare.com/learning/cdn/glossary/reverse-proxy/

* Load balancers can decrease latency by re-routing traffic from unhealthy VMs to healthy instances.  It is not the only way to decrease latency and should be used with a Cloud CDN.  Anycast IP allows servers to share a single IP address.  This allows clients all over the world to automatically select the closest server, reducing latency. https://www.thousandeyes.com/learning/techtorials/anycast

* URL maps are used to determine the destination of a request based on the path (ie. /colombia vs /thailand).  Routing rules use attributes such as headerNames, exactMatch. https://docs.cloud.google.com/load-balancing/docs/url-map#terraform

## Cloud Armor
* Cloud Armor is a layer 7 web application firewall.  It protects against HTTP(S) style cyber attacks.  VPC firewall rules only dictate the flow of traffic, whereas Cloud Armor protects your application before the traffic is delivered. https://cloud.google.com/security/products/armor?hl=en 

* Rate based rules protect an application from suspicious actions from a single IP address.  It limits the number of requests an IP address can make. https://www.cloudflare.com/learning/bots/what-is-rate-limiting/

* reCAPTCHA is a service that monitors an application or service for possibile bot activity.  It can be used to slow or even stop scalpers from using bots.  A reCAPTCHA can work with rate based rules to determine if activity from an IP address is suspicious.
https://cloud.google.com/security/products/recaptcha?hl=en 

## Cloud CDN
* Points of Presence or POPs are physical locations that house edge servers responsible for server cached content.  Typically static files needed to load a webpage such as images, HTML, are delivered to clients.  CDNs can also deliver videos to users.
https://www.keycdn.com/what-is-a-cdn#:~:text=A%20point%20of%20presence%2C%20commonly,make%20up%20the%20entire%20network 
https://www.cloudflare.com/learning/cdn/what-is-a-cdn/ 

* External HTTP(S) load balancers, VM instances and Cloud Armor are a handful of services that can be used with Cloud CDN.  Cloud CDN does not protect against cyberattacks.  Its purpose is to deliver cached content to global clients.
https://docs.cloud.google.com/cdn/docs/overview

* An enterprise should consider using Cloud CDN.  Because the service is global, no matter where in the world clients are accessing an enterprise's application from, the will be able to experience low latency.  Cloud CDN is a key aspect of High Availability. 

* Time to live or TTL tells a cache the of the length of time data can be considered as fresh.  When the TTL expires, CDN revalidates its content from the origin server and deliver future requests any updated content through its edge servers.


# Runbook
* The goal of this runbook is to provision an external application global load balancer

  ## Prerequistes
    1. An instance template
    2. Health check configuration

  ### Steps

  1. Open the Instance groups page
  2. Click **Create Instance Group**
  3. On the Create Instance Group  page enter the following details
      ```
      Name = 'Satellite-x23'
      Description = "Production Support Instances"
      ```
  4. Click on Instance template dropdown and select the instance template
  5. Change the number of instances from 1 to 4
  6. Under the Location section, ensure **Multiple zones** is selected 
  7. Ensure **Region** is us-central1 (Iowa)
  8. Click on the Zones dropdown and ensure all four zones are selected
  9. Leave the Target distribution shape as **Balanced**
  10. Click on **Configure Autoscaling**
  11. Ensure **On: add and remove instances to the group** is selected
  12. Set the minimum number of instances to 2 and the maximum number of instances to 8
  13. Edit the Autoscaling signal to the following
      ```
      Signal type = 'CPU Utilization'
      Target CPU Utilization = "70"
      Predictive autoscaling = Optimizae for availability
      ```
  14. Edit the Initlization period to
       ```
      Initlization period = 120
      ``` 
  15. Ensure that **Repair instance** is selected under Action on failure
  16. Click on Health check and select a health check implementation
  17. Click on **Create**

  ## Settings Definitions
  1. Autoscaling signals - this is what will determine if our instance group will add additional VMs based on the CPU utilization
  2. Initlization period - time it takes for a VM to become ready for use
  3. Autohealing - creates a VM instance if it fails a load balanceer health check

## Terraform
* When creating a VM in terraform, the following arguments are required:
  * boot_disk - the OS and storage information for our VM
  * machine_type - the series of machine we wish to provision.  Depending on requirements, one Series may be needed over another

## Sources

* The below sources were used to build this README and the project it is associated with.  All HA, Autoscaling and Health Check sources were used to gather definitions and use cases.  Terraform sources were used to build the attached project.

| Topic  | Link |
| ------------- |:-------------:|
| HA vs Fault Tolerance      | https://www.couchbase.com/blog/high-availability-vs-fault-tolerance|
| HA vs Fault Tolerance IBM    | https://www.ibm.com/docs/en/powerha-aix/7.2.x?topic=aix-high-availability-versus-fault-tolerance     |
| HA vs Fault Tolerance Scale computing     | https://www.scalecomputing.com/resources/fault-tolerance-vs-high-availability   |
|nOps | https://www.nops.io/blog/cloud-scalability|
|Auto scaling vs elasticity | https://tenmilesquare.com/capabilities/scalability-architecture/auto-scaling-and-elasticity|
| Instance groups | https://docs.cloud.google.com/compute/docs/instance-groups|
| 3 Tier architecture| https://www.ibm.com/think/topics/three-tier-architecture|
|Health Check Overview| https://docs.cloud.google.com/load-balancing/docs/health-check-concepts?utm_source=chatgpt.com|
|  Terraform Registry Google_compute instance| https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance#network_interface.0.access_config.0.nat_ip-1|
|Terraform Registry google_compute_region_instance_group_manager|https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_instance_group_manager|
|Terraform Registry google_compute_instance_template| https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template|
