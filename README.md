# Terraform AWS-Azure mutlicloud setup

<strong>Project aimed at creating simple site-to-site VPC to VNet connection between Azure and AWS utilizing BGP and IPsec for safe data transfer.</strong>
<br><br>
The topology below is a starter topology for further experiments such as shared multicloud storage, pipelines, terraform provisioning. 

This repository will be updated with each change documented. 

<strong>THIS IS NOT PRODUCTION INFRASTRUCTURE</strong> --> certain practices here differ a lot from real world scenarios and are not necessary good to apply mainly due to cost/complexity/security reasons. 
Take it as my sandbox to learn terraform + terragrunt later on, while experimenting with multicloud setup.



<img src="https://github.com/user-attachments/assets/b59e7d7b-a01e-4819-8f28-685d300e4132.svg" alt="terraform" width="50" height="50" style="margin-right: 8px;"/>

<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128"><g fill-rule="evenodd"><path d="M77.941 44.5v36.836L46.324 62.918V26.082zm0 0" fill="#5c4ee5"/><path d="M81.41 81.336l31.633-18.418V26.082L81.41 44.5zm0 0" fill="#4040b2"/><path d="M11.242 42.36L42.86 60.776V23.941L11.242 5.523zm0 0M77.941 85.375L46.324 66.957v36.82l31.617 18.418zm0 0" fill="#5c4ee5"/></g></svg>
