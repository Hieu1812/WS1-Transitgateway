+++
title = "implement Transit Gateway to create connection between VPCs"
date = 2024
weight = 1
chapter = false
+++

# implement Transit Gateway to create connection between VPCs. 

#### Overview

At this workshop, we will implement  **Transit Gateway** to create connection between VPCs. 
Also, we will create **EC2 Instance** for each VPCs to check the connection.
![img](/images/graph.png)
<!-- them hinh graph -->

#### VPC peering vs Transit Gateway
- In fact, VPC peering and Transit Gateway both help users connect VPCs together in the internal network. But depending on the scale of the system we choose. With a system of only 3 VPCs or less, we can use VPC peering with 3 peering connections. When the system is complex, the more VPC you make, the more peering conection will be created. which is inconvenience, difficulty in control and low scalability. That is why we have Transit Gateway.
#### Transit Gateway
- Solve the disadvantages of Peering Conenction, Transite Gateway is used to connect VPC and on-premises network through a hub. This simplifies the network and ends complex routing relationships.
#### VPC
- Amazon Virtual Private Cloud (Amazon VPC) is a service that lets you launch AWS resources in a logically isolated virtual network that you define. You have complete control over your virtual networking environment, including selecting your IP address range, creating subnets, and configuring route tables and network gateways.
#### EC2 Instance
- As a cloud computing infrastructure provided by Amazon Web Services (AWS) that provides virtualized computing resources on demand. Similar to servers, EC2 is created quickly and ensures the highest availability.

{{% notice info %}}The reference terraform file for this workshop [Link](https://github.com/Hieu1812/WS1-Transitgateway/blob/main/main.tf){{% /notice %}}
#### Content:
1. [Create VPC](1-VPC)
2. [Create EC2](2-EC2)
3. [Create Transit Gateway](3-Transit%20Gateway)
4. [Transit Gateway Attachment for each VPC](4-Transit%20Gateway%20Attachment) 
5. [Create Transit Gateway route table and test ](5-Transit%20Gateway%20route%20table)
6. [Clean up](6-Clean%20up)