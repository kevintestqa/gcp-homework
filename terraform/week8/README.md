# Q & A
## High Availability vs Fault Tolerance
* High Availabily (HA) is the measure of an environment's avalability to minimize service disruptions.  This is accomplished by implementing failover protocols such as Read Replicas (used in the event our primary database is unreachable and our application is not Write heavy), implementing load balancers (ensuring traffic is evenly distributed to our virtual machines and other infrastructure elements), health checks  (ensures that our virtual machines or our application met satisfactory metrics before replacing them if needed), and placing our environment in multiple regions.  Having our services span multiple zones/ regions allows our services to remain running in the event of a zone or regional outage.

* Fault tolerance is our infrastructure's ability to continue full service amid *unexpected* service disruptions. It can be significantly more expensive than developing an HA solution.

* Although both solutions aim for a high quality client experience, choosing HA or fault tolerance is dependent on the industry, staff expertise and budget.  An e-commerce company may choose to focus primarily on HA because it can implement autoscaling when the demand calls for it (i.e major holidays or product releases).  Wherease a brokerage firm may pritiorize fault tolerance due to the need of their clients to have accurate trading and account information. 

## Autoscaling vs Elasticity
* Autoscaling refers to the ability of our infrastrature to adjust capacity based on demand.  The two types of scaling are vertical and horizontal scaling.  Vertical refers to adjusting the size of elements in our environment.  For example, if we need an instance type with larger storage or one with more GPU cores, then our environment will *vertically* scale up in size.  Horizontal scaling *adds* more of the same resource to deal with increased demaind. Environments can also scale down with decreased demand.  Generally speaking, horizontal scaling is prefered, as more compute resources the environment can scale to in conjunction with load balancers directing traffic to the resources, the better the customer experience.  

* Elasticity refers to the environment's abilty to gracefully scale resources up and down based on demand. The ability to vertically and horizontally scale is one of the many advantages of using the cloud.  Scaling on prem is not feasible due to the complexcity of purchasing hardware, installing the equipment and neccsary software.  This creates huge operational overhead compared to the cloud, where resources are scaled up and down depending on KPIs we define and the organization only pay for the resources that are used.  

## Managed vs Unmanaged Instance groups
* Managed Instance Groups(MIGs) allows us to operate apps on identical VMs based on an Instance template.  As a result it is much more efficent at launching a fleet of VMs than creating each VM one at a time.  These types of instance groups allow for autoscaling, autohealing, multi zone deployment and updating performed by Google.  For environments that need consistent configuration, a MIG is ideal.  
* Unmanaged Instance Groups on the other hand are a collection of VM that may have different configurations.  The user manages this group and as a result does not support autoscaling nor autohealing.

## Health Checks
* Load balancers use health checks to determine if a VM instance is healthy enough to recieve traffic.  This is done through a series of probes.  Based on a criteria provided by users, the instance will be determined as healthy.  If an instanace fails its series of probes, the load balancer will declare the instance as unhealthy and ceasing routing traffic to it.

* Instance groups use health checks to determine if an application installed on a VM is responding accordingly.  If the VM fails, then the MIG would either start the autohealing process.  It is recommended to use health checks for both load balancers and applications.

## 3 Tier Architecture
* The 3 tier architecture is a type of software architecture that separates the presentation, application and data entities.  The presentation layer is responsibile for providing the user interface clients will interact with.  The application layer contains the application's business logic.  The final layer is charged with storing and managing the logic in the application layer processes.  

* Our lessons prepare me for desiging and implementing an environment that any size firm can use.  For example, the material covering autoscaling teaches students an important tool in ensuring the health of the application layer.  It also implies priotizing user experience. Building the pieces of our infratstrure, teaches architectural design - specifically choosing the right services to implement based on application requirements.

# Runbook
* The goal of this runbook is to provision a managed instance group with our standard configuration of 4 VM instances

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
* 

### Unordered

* Item 1
* Item 2
* Item 2a
* Item 2b
    * Item 3a
    * Item 3b

### Ordered

1. Item 1
2. Item 2
3. Item 3
    1. Item 3a
    2. Item 3b

## Images

![This is an alt text.](/image/Markdown-mark.svg "This is a sample image.")

## Links

You may be using [Markdown Live Preview](https://markdownlivepreview.com/).

## Blockquotes

> Markdown is a lightweight markup language with plain-text-formatting syntax, created in 2004 by John Gruber with Aaron Swartz.
>
>> Markdown is often used to format readme files, for writing messages in online discussion forums, and to create rich text using a plain text editor.

## Tables

| Left columns  | Right columns |
| ------------- |:-------------:|
| left foo      | right foo     |
| left bar      | right bar     |
| left baz      | right baz     |

## Blocks of code

```
let message = 'Hello world';
alert(message);
```

## Inline code

This web site is using `markedjs/marked`.
