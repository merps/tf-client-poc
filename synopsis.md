# F5 Network Hybrid Deployment Options - Pre-Sales Case #

This document will outline the available options to deploy consistent architecture between OnPremises, AWS and GCP as a 
Proof-of-Concept (PoC) for Cloud Migration Project to be undertaking withSystem Integrator (SI)

## Day0/Planning
----------------

### Requirements

It has been noted that the functional requirements (FR) for this Proof-of-Concept are as follows:

* F5 should use Terraform for autoscale deployment unlike CFT or GDM
* F5 will get deployed in Across-Zone/regional in both the cloud (GCP and AWS)
* It should have NLB/ILB on the top to distribute the traffic and supporting the scaling of F5s
* All the devices should be in config-sync cluster or some other mechanism to perform the sync (either via 
BIG-IQ or buckets)
* Revocation of license should be handled automatically on BIG-IQ
* Single Partition deployment.

The current OnPremise deployment consists of BIG-IQ (v8.0) and associated BIG-IP's for management, the client would 
like to leverage this framework moving forward for auto-scaled cloud instances.


#### AWS Deployment Architecture

At a High Level, as the information provided is prescriptive due to client requirements, the architecture is consistent 
with the TGZ (Transit Gateway) Landing Zone Pattern.

It is assumed the TGZ resides within the `Network & Security Account` that hosts the VPC's that will be routed back to 
OnPremise.

The `Gatway VPC` serves as DirectConnect (DXC) termination account hosting across AZ's Public, Private and Management 
subnets

Connected via the TGZ the `Internet Inbound VPC`, hosting same subnet pattern as `Gateway VPC`, is where BIG-IP AWAF 
1nic autoscaling instances will reside behind Internet facing NLB's (elb.v2).  The current desired deployment pattern


#### GCP Deployment Architecture

As above, additional information to be provided.


#### Deployment Tools & Configuration Management

The client has shared the follow, thus far, for the cloud migration PoC:

| Toolset | Function |
| --------| -------- |
| GitHub | Source control
| Terraform | Deployment IaC framework|
| Ansible | Configuration Management|
| Jenkins | Application Deployment|


#### BIG-IP Life Cycle (Day0)

Client is currently provisioning BIG-IP VE's via Image Builder, another alternative to this is Packer, 
both options and examples listed;

##### Build/Create Runtime:

* [F5 BIG-IP Image Generator Tool](https://clouddocs.f5.com/cloud/public/v1/ve-image-gen_index.html)
* [HashiCorp Packer (AWS)](https://github.com/alexapplebaum/f5-packer-templates/tree/aws/bigip-13.0.0-aws-asm)


##### Create / Update Deployment (Autoscale Model + LB Pool)

##### HashiCorp Terraform FOSS

Based on client requirements the following information, for AWS, can be leverage;

* [AutoScale based on ELK telemetry (example)](https://github.com/f5devcentral/adc-telemetry-based-autoscaling)
* [AutoScale based on LB (example)](https://github.com/JeffGiroux/f5_terraform/tree/main/AWS/Autoscale_via_lb)

##### Caveats

The usage of`config-sync` is not advised because this does not function correctly with AutoScaling immutable BIG-IP as 
tracked per [BugID:1013065](https://bugzilla.olympus.f5net.com/show_bug.cgi?id=1013065)

At this time, it's best to **not** recommend this approach with the approach for the client.

## Day1/Updates
----------------

With Day1 operations there is multiple approaches that can be taken with relation to configuration management, 
as listed;

* [Cloud Native (CSP) Autoscaling Options](#csp)
* [F5 Networks Deployment/Configuration Management via BIG-IQ](#big-iq)


### CSP

Leveraging the AutoScale Model for CSP's (AWS/GCP) initial provisioning and Declarative Onboarding (DO) can be used to 
provide and ensure consistency across the BIG-IP Fleet.  All Config updates via the Autoscale Model, this model ensures 
consistency across fleet and makes use of CSP specific [`cloud-init`](https://cloudinit.readthedocs.io/en) that also 
aligns with the use of DO & `runtime-init`

Defined as [`user-data`](https://cloudinit.readthedocs.io/en/latest/topics/format.html) updates for `cloud-init`
Update User-Data

* AWS = [UserData](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-add-user-data.html)
* GCP = [metadata startup-script](https://cloud.google.com/compute/docs/reference/rest/v1/instances)
* Templates 2.0 = bigIpRuntimeInitConfig (AWS CFN & GCP GDM)

The advantage of [`runtime-init`](https://github.com/F5Networks/f5-bigip-runtime-init) is that this Domain Specific 
Language (DSL) can also be executed within `user-data` of AutoScaling launch configurations.

CSTv2 deployment pattern for Immutable WAF Autoscale is seen in the accompanying [diagram](asg_waf.png).


### BIG-IQ 

The client currently manages the OnPremise BIG-IP fleet and requested the extension of this to include Cloud Editions 
within this existing maintenance framework.  Integration & customisation of IaC and Application workloads for migration 
in this initial phase will need to be scoped due to AWS TGZ Landing Zone Pattern, this will include but not limited to 
- AWS specific - the validation of;

* AWS
    * Security Groups (SG's)
    * Network Access Lists (NACL's)
    * IAM Groups and Roles for STS
    * S3 ObjectStore Access
    * TGZ Routes/Flows
    * (A/N)LB for Autoscaling
    * Gateway VPC and DXC

* OnPremises
    * AWS CGW's
    * OnPremises DXC;
        * Network Routing & connectivity
        * Firewalls and security


Leveraging the existing BIG-IQ Centralised management, Terraform and Maintenance/Monthly build images configured with 
`user-data` variables for onboarding and configuration connectivity to BIG-IQ from Cloud Instances of BIG-IP can 
achieve the requested [PoC requirements](#requirements).

[Application configuration and deployment using AWX/Ansible tower](https://clouddocs.f5.com/training/community/big-iq/html/class1/lab3.html) 
demonstrates how BIG-IQ in conjunction with BIG-IP can be used to demonstrate deployment pipelines.


### TODO 
 - [] clean/insert finalised flow and source from [testing](https://gitlab.wirelessravens.org/f5labs/tf-client-poc)
 - [] revise Terraform [BIG-IQ](https://github.com/merps/terraform-aws-bigiq) module for v8.x
 - [] DCEC for Solution with TGZ and Inspect VPC as per LandingZone Pattern
 - [] `cloud-init` JSON payload either via DO or `runtime-init`
 - [] additional calls for BIG-IQ Postman collection

## References

####  DevOps/AWS

- https://dev.to/souzaxx/rolling-update-ec2-with-terraform-13bf
- https://medium.com/@endofcake/using-terraform-for-zero-downtime-updates-of-an-auto-scaling-group-in-aws-60faca582664
- https://aws.amazon.com/blogs/compute/introducing-instance-refresh-for-ec2-auto-scaling/
- https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/migrate-an-f5-big-ip-workload-to-f5-big-ip-ve-on-the-aws-cloud.html
- https://docs.aws.amazon.com/prescriptive-guidance/latest/migration-f5-big-ip/migration-f5-big-ip.pdf

#### F5 - External

- [K82540512: Overview of the UCS archive 'platform-migrate' option](https://support.f5.com/csp/article/K82540512)
- [Cloud-Init and BIG-IP VE](https://clouddocs.f5.com/cloud/public/v1/shared/cloudinit.html)
- [BIG-IP VE in AWS](https://clouddocs.f5.com/cloud/public/v1/aws_index.html)
- [K33973570: BIG-IP update and upgrade guide - F5 AWS CloudFormation Templates 1.0](https://support.f5.com/csp/article/K33973570)
- [K40194928: BIG-IP update and upgrade guide -  BIG-IP GCP VM using Terraform](https://support.f5.com/csp/article/K40194928)
- [Amazon Web Services: Single NIC config sync across Availability Zones - Static Infrastructure](https://clouddocs.f5.com/cloud/public/v1/aws/AWS_configsync.html) 
- [K15886: Restore the BIG-IQ system to factory default settings](https://support.f5.com/csp/article/K15886)
- [K13946: Troubleshooting ConfigSync and device service clustering issues](https://support.f5.com/csp/article/K13946)
- [BIG-IQ 8.1.0.1 Product Team Demo/Lab](https://udf.f5.com/b/c3c55870-510f-49d1-b211-b4c8acc58fb6#documentation)
- [BIG-IQ Test Drive Labs](https://clouddocs.f5.com/training/community/big-iq-cloud-edition/html/bigiqtestdrive.html)
- [Lab 3: AS3 Application creation and deletion using AWX/Ansible Tower and BIG-IQ](https://clouddocs.f5.com/training/community/big-iq/html/class1/lab3.html)

#### F5 - Community

- [AWS AutoScale `run-time` Init](https://github.com/f5-applebaum/terraform-aws-bigip/tree/runtime-init-autoscale/examples/autoscale_with_new_vpc)
- [GCP AutoScale](https://github.com/JeffGiroux/f5_terraform/tree/main/GCP/Autoscale_via_lb)
- [ADC Telemetry AutoScale](https://github.com/f5devcentral/adc-telemetry-based-autoscaling)
- [TGW AWS deployment example](https://gitlab.wirelessravens.org/f5labs/tf-client-poc)
- [Packer Build Example](https://github.com/smooth-alg/f5-packer-templates/tree/aws/bigip-13.0.0-aws-asm)

#### F5 - Internal

- [Cloud Solution Templates (CST v2) Usage](https://f5.sharepoint.com/sites/EMEASystemsEngineering/SitePages/Cloud-Solution-Templates-2.0-(CST2).aspx)
- [PMO Cloud Solution Templates](https://f5.sharepoint.com/sites/PMAOCollaboration/Shared%20Documents/Forms/AllItems.aspx?id=%2Fsites%2FPMAOCollaboration%2FShared%20Documents%2FEcosystem%20%2D%20Public%20Cloud%2FCST2%20Phase%202%2FCloud%20Solution%20Templates%202%2E0%20Solution%20Overview%2Epdf&parent=%2Fsites%2FPMAOCollaboration%2FShared%20Documents%2FEcosystem%20%2D%20Public%20Cloud%2FCST2%20Phase%202)
- [ConfigSync Immutability Bug](https://bugzilla.olympus.f5net.com/show_bug.cgi?id=1013065)






