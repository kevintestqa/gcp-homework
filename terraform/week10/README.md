# Q & A

## Table of Contents

- [Q & A](#q-&-a)
  - [DNS & SSL/TLS](#dns-&-ssl/tls)
  - [Load Balancers](#load-balancers)
  - [Cloud Domain/DNS](#cloud-domain/dns)
- [Runbook](#runbook)


## DNS & SSL/TLS
* Both traceroute and dig are command line networking troubleshooting tools.  While the dig command assists with checking if a domain resolves to the desired IP address, traceroute presents the path(hops) that packets travel to reach the desired destination.  Traceroute pinpoints where possible error may occur on their trip.  Dig is useful for viewing DNS records in detail. **Source:** https://blog.crowncloud.net/post/how-to-test-network-connectivity-in-linux-ping-traceroute-dig-nslookup/.

<table>
  <tr>
    <td>
      <img src="Assets/DigOutput.png" alt="DigOutput" width="400">
      <br><em>Example of Dig command output.</em>
    </td>
    <td>
      <img src="Assets/TracerrouteOutput.png" alt="TracerouteOutput" width="400">
      <br><em>Example of Traceroute command output.</em>
    </td>
  </tr>
</table>

* The most common DNS record types are A, AAAA, MX, and CNAME.

| Record        | Use Case |
| ------------- |-------------|
| A             | Resolves DNS name to its IPv4 address|
| AAAA          | Resolves DNS name to its IPv6 address|
| MX            | Used by email applications to identify authorized email servers|
| CNAME         | Used to point a domain to another domain's name| 
**Source:** https://keetmalin.medium.com/common-dns-record-types-explained-fe0a83d20115 & https://youtu.be/HnUDtycXSNE?si=cFBhSM0kctJ2FNDX 

* URL maps are used to determine the destination of a request based on the path (ie. /colombia vs /thailand).  Routing rules use attributes such as headerNames, exactMatch. https://docs.cloud.google.com/load-balancing/docs/url-map#terraform

## Load Balancers
* Cloud Armor is a layer 7 web application firewall.  It protects against HTTP(S) style cyber attacks.  VPC firewall rules only dictate the flow of traffic, whereas Cloud Armor protects your application before the traffic is delivered. https://cloud.google.com/security/products/armor?hl=en 

* Rate based rules protect an application from suspicious actions from a single IP address.  It limits the number of requests an IP address can make. https://www.cloudflare.com/learning/bots/what-is-rate-limiting/

* reCAPTCHA is a service that monitors an application or service for possible bot activity.  It can be used to slow or even stop scalpers from using bots.  A reCAPTCHA can work with rate based rules to determine if activity from an IP address is suspicious.
https://cloud.google.com/security/products/recaptcha?hl=en 

## Cloud Domain/DNS
* Points of Presence or POPs are physical locations that house edge servers responsible for serving cached content.  Typically static files needed to load a webpage such as images, HTML, are delivered to clients.  CDNs can also deliver videos to users.
https://www.keycdn.com/what-is-a-cdn#:~:text=A%20point%20of%20presence%2C%20commonly,make%20up%20the%20entire%20network & https://www.cloudflare.com/learning/cdn/what-is-a-cdn/ 

* External HTTP(S) load balancers, VM instances and Cloud Armor are a handful of services that can be used with Cloud CDN.  Cloud CDN does not protect against cyberattacks.  Its purpose is to deliver cached content to global clients.
https://docs.cloud.google.com/cdn/docs/overview

* An enterprise should consider using Cloud CDN.  Because the service is global, no matter where in the world clients are accessing an enterprise's application from, they will be able to experience low latency. 

* Time to live or TTL tells a cache the length of time data can be considered as fresh.  When the TTL expires, CDN revalidates its content from the origin server and deliver any updated content to future requests through its edge servers.


# Runbook
* The goal of this runbook is to provide engineers strategies to troubleshoot a VNM

  ### Section 1 - Steps to create an Instance Group
  * The goal of this section is to configure an Instance group that will be used as our backend for the external application global load balancer

  1. Open the Instance groups page
  2. Click **Create Instance Group**
  3. On the Create Instance Group  page enter the following details
      ```
      Name = 'orion-x33'
      Description = "QA Environment Support"
      ```
  4. Click on Instance template dropdown and select a global instance template
  5. Change the number of instances from 1 to 3
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
      Predictive autoscaling = Optimize for availability
      ```
  14. Edit the Initialization period to
       ```
      Initialization period = 120
      ```
  ### Section 2 - Steps to create a Global External Application Load Balancer
  * The goal of this section is to create a Global External Application Load Balancer

  1. Ensure that **Repair instance** is selected under **Default Action on failure**
  2. Click on **Health check** and select a global health check implementation
  3. Set the Initial delay to 300 seconds
  4. Ensure **Default Action** is selected under **On failed health check**
  5. Click on **Create**
  6. Once the MIG is created, click on the search bar and search for **Load Balancing**
  7. Click on **Create load balancer**
  8. Use the following name for the Load Balancer
   ```
     Name = qae01-lb
    ```
  9. In the **Type of load balancer** section, ensure **Application Load Balancer** (HTTP/HTTPS) is selected (it should be selected by default) and click on **Next**
  10. In the **Public facing or internal** section, ensure **Public facing (external)** is selected (it should be selected by default) and click on **Next**
  11. In the **Global or single region deployment** section, ensure **Best for global workloads** is selected (it should be selected by default) and click on **Next**
  12. In the **Load balancer generation** section ensure **Global external Application Load Balancer** is selected (it should be selected by default) and click on **Next**
  13. Tap on **Configure**

  ### Section 3 - Steps to configure Frontend IP and Backend Buckets
  * The goal of this section is to configure the Frontend IP and Backend Buckets to the Application Load Balancer

  1. Under **New Frontend IP and port** enter the following configuration:
    ```
     Name = qae01-frontend
     Description = qa frontend
     Protocol = HTTP
     IP Version = IPv4
     IP address = Ephemeral (Automatic)
     Port = 80
    ```
  2. Click on **Backend Configuration** and select a Backend bucket under **Backend services & backend buckets**
  3. Click on **OK** to confirm
  4. Click on **Routing rules** and ensure **Simple host and path rule** is selected
  5. Under **Host and path rules** ensure the backend selected is the *same* backend bucket selected in step 3.2
  6. Click on **Review and finalize** to verify the configuration
  7. Click on **Create**

  ### Section 4 - Steps to configure the MIG to the ALB Backend Service
  * The goal is to integrate the created MIG with the ALB's backend service

  1. On the Load balancing homepage, click on **Create backend service**
  2. Click **Create** under **Global backend service**
  3. Fill out the backend service with the following:
    ```
     Name = qae01-backend
     Description = qa backend service
     Load Balancer type = Global external Application Load Balancer (EXTERNAL_MANAGED)
     Backend type = Instance group
     Protocol = HTTP
     Named port = http
     Timeout = 60
     IP address selection policy = Only IPv4
     Health check = The same health check selected in Section 2.2
    ```
  4. Fill out the **Backends** section with the following: 
    ```
     IP stack type = IPv4 (single-stack)
     Instance group = orion-x33
     Port numbers = 80
     Balancing mode = Rate
     Traffic Duration = Default (Short)
     Maximum RPS = 100
     Scope = per instance
     Capacity = 100
     Backend preference level = None
    ```
  5. Disable Cloud CDN
  6. Do not select a Cloud Armor backend security policy
  7. Click on **Create**

  ### Section 5 - Checks
  1. In the **Backends** tab, verify that there are rows for the bucket selected in section 3.2 and the newly created backend service
  2. Click on the backend and verify that the orion-x33 instance group is presented
  3. Navigate to the Instance groups page and verify the **In Use By** column contains **qae01-backend** is presented