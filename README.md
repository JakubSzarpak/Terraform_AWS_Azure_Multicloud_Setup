# Terraform AWS-Azure mutlicloud setup

<strong>Project aimed at creating simple site-to-site VPC to VNet connection between Azure and AWS utilizing BGP and IPsec for safe data transfer.</strong>
<br><br>
The topology below is a starter topology for further experiments such as shared multicloud storage, pipelines, terraform provisioning. 

This repository will be updated with each change documented. 

<strong>THIS IS NOT PRODUCTION INFRASTRUCTURE</strong> --> certain practices here differ a lot from real world scenarios and are not necessary good to apply mainly due to cost/complexity/security reasons. 
Take it as my sandbox to learn terraform + terragrunt later on, while experimenting with multicloud setup.

<br>
<h3 align="left">Languages and Tools used in this project:</h3>
<p align="left">
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/terraform/terraform-original.svg" alt="csharp" width="50" height="50" style="margin-right: 8px;"/>
  <img src="https://www.vectorlogo.zone/logos/microsoft_azure/microsoft_azure-icon.svg" alt="azure" width="50" height="50" style="margin-right: 8px;"/>
  <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/amazonwebservices/amazonwebservices-original-wordmark.svg" alt="aws" width="50" height="50" style="margin-right: 8px;"/>
</p>

<br>
