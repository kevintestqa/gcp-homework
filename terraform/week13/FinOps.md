# FinOps Guide

## Table of Contents

- [Q & A](#q--a)
  - [DNS & SSL/TLS](#dns--ssltls)
    - [TLS Handshake Process](#tls-handshake-process)
  - [Load Balancers](#load-balancers)
  - [Cloud Domain/DNS](#cloud-domaindns)
- [Jira Ticket](#jira-ticket)
  - [Section 1 - www.jira.com/GCP-1234](#section-1---wwwjiraccomgcp-1234)
  - [Troubleshooting Process](#troubleshooting-process)
  - [Root Cause](#root-cause)

## What are Cloud Notifications?

* Cloud Notifications assits organizations manage their cloud usage.  For example, departments such as FinOps or a Cloud Center of Excellence use notifications to monitor cloud spend.

**Source:** https://docs.cloud.google.com/monitoring/support/notification-options.
https://docs.cloud.google.com/monitoring/alerts 


### How to set Cloud Notifications (SMS)

* Prerequiste- project must have the Monitoring Editor IAM role.
**Source:** https://docs.cloud.google.com/monitoring/support/notification-options 

1. Navigate to the Alerting page in GCP
2. Select the desired project you want to create alerts for
3. Click on **Edit notification channels**
4. In the SMS section click **Add New**
5. Enter the phone number and display name
6. Click on **Send Verification Code**
7. Enter the 6 digit code Google sends and click on **Verify**

## How to set Budget Alerts
1. Navigate to the Budgets and ALerts page in GCP
2. Select the desired project you want to create alerts for
3. Click on **Create budgets**
4. Enter desired budget name
5. Select the deisred Time range
6. Select the projects that the budget will be focused on
7. Select the desired service(s)
8. Under **Savings** select Savings programs and Other Savings and click on **Next**
9. Enter the Target amount and click on **Next**
10. Edit the alert threshold rules to desired values
11. Select the desired notification channels (Email alerts to billing admins and users should be selected by default)
12. Click on **Finish**

* The HTTPS Proxy is the service that offloads SSL.  This is done through the SSL/TLS handshake process.



## Cloud Domain/DNS

* Multiple domains can point to the same LB.  An example is amazon.com and aws.amazon.com.  Zones can be thought of as boxes that contain a DNS record(s).  The two types of zones are public and private.  A DNS in a public zone exposes it to the internet.  On the other hand, a private zone a DNS is exposed only to the VPC it belongs in.

**Source:** https://docs.cloud.google.com/dns/docs/dns-overview#private_zone

# Jira Ticket

### Section 1 - Link to Jira Ticket - www.jira.com/GCP-1234

* **Title** - VM Instance cannot connect to the internet
* **Description** - VM could not be accessed from external clients.
* **Expected behavior** VM should be able to be accessed from external clients
* **Current behaviors**:
  1. VM is initially marked as Stopped
  2. Application is unreachable via SSH or browser

  ![Jira ticket GCP-1234](Assets/GCP-Jira-1234.png)

### Troubleshooting Process

1. Open the VM Details Page and noticed the instance is marked as "Stopped"
2. Checked subnet details
3. Checked Firewall rules and noticed the Deny All rule had a Priority of 0

   ![Firewall rule with Priority 0](Assets/firewall-rule.png)

   * Changed the Deny All rule's Priority to 1200
     * Restarted VM and ensured it was in the "running" status
   * Checked SSH access and was presented with the Received Connection via Cloud Identity-Aware Proxy Failed error

     ![SSH in browser error](Assets/SSH-in-browser.png)

     * Compared SSH Firewall rules and noticed the source range does not match the range the error suggested

       ![Identity-Aware Proxy source range mismatch](Assets/Aware-Proxy-Failed.png)

       * Changed IPv4 source range to what range the error mentioned

       ![IPv4 range change](Assets/iPv4-ranges.png)

4. Opened SSH window for the instance and pinged Google. Although packets were transmitted, 0 were received by the client

   ![SSH packet transmitted](Assets/packet-received.png)

5. Opened VM details and saw that the firewalls were not checked

   ![Firewalls selection](Assets/Firewalls.png)

   * Selected Allow HTTP Traffic and saved changes

6. Checked details of the VM's startup script
   * Opened the Network Interfaces for the VM and noticed that external IPv4 address was set to "None". As a result, changed the external address to "Ephemeral"

7. Attempted to access VM through client browser
8. Navigated back to VM's Network Interface details and noticed the lack of a route to the internet gateway

   ![Network Interface details](Assets/Network-config-analysis.png)

9. Opened the Routes page and clicked on Route Management to create a route and associate it to the VM's VPC

   ![Routes configuration](Assets/Create-route.png)

10. Returned to the VM's Network Interface details to ensure the route was successfully created

    ![Routes configuration](Assets/Routes-config.png)

11. Re-opened the SSH browser and pinged Google.com
12. Accessed the VM via a web browser

### Root Cause

* VM did not have an external IP address.  In addition, VM did not have a route to the public internet.  By creating a route, the VM was able to be accessed by an external browser and SSH functionality was restored.  Suggestion for future deployments: have QA team test and sign off.