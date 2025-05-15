#############################################################################################
################ Creating all resources on us-east-1 --> N. Virginia ########################
#############################################################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}


#################################################################
######## 1. Create VPC for site-to-site connectivity ############
#################################################################

resource "aws_vpc" "aws-to-azure-vpc1" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

variable "project_name" {
  description = "Name prefix for all resources dedicated for this project"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the site-to-site purposed VPC"
  type        = string
}


########################################
#### 2. Create VPN Gateway -> Azure ####
########################################
resource "aws_vpn_gateway" "azure" {
  vpc_id          = aws_vpc.aws-to-azure-vpc1.id
  amazon_side_asn = var.aws_vpn_asn
  tags = {
    Name = "${var.project_name}-vpn-gateway"
  }
}

variable "aws_vpn_asn" {
  description = "BGP ASN for the Virtual Private Gateway"
  type        = number
}


#############################################
# 3. Customer Gateway ToAzureInstance0   ####
#############################################
resource "aws_customer_gateway" "ToAzureInstance0" {
  bgp_asn    = var.azure_bgp_asn
  ip_address = var.azure_public_ip1
  type       = "ipsec.1"
  tags = {
    Name = "${var.project_name}-cgw-instance0"
  }
}

variable "azure_bgp_asn" {
  description = "BGP ASN of Azure VPN Gateway"
  type        = number
}

variable "azure_public_ip1" {
  description = "Public IP of Azure vgn" # This is dynamic --> need to retrieve from Azure Tenant first --> then define in tfvars
  type        = string
}


#############################################
# 4. Customer Gateway ToAzureInstance1  ####
#############################################



resource "aws_customer_gateway" "ToAzureInstance1" {
  bgp_asn    = var.azure_bgp_asn
  ip_address = var.azure_public_ip2
  type       = "ipsec.1"
  tags = {
    Name = "${var.project_name}-cgw-instance1"
  }
}


variable "azure_public_ip2" {
  description = "Public IP of Azure vgn" # This is dynamic --> need to retrieve from Azure Tenant first --> then define in tfvars
  type        = string
}


##################################################################
# 5. Site-to-Site VPN Connection ToAzureInstance0 (BGP-enabled) ##
##################################################################
resource "aws_vpn_connection" "to_azure_instance0" {
  vpn_gateway_id      = aws_vpn_gateway.azure.id
  customer_gateway_id = aws_customer_gateway.ToAzureInstance0.id
  type                = "ipsec.1"

  static_routes_only = false

  tunnel1_inside_cidr   = var.apipa_tunnel0_cidr
  tunnel1_preshared_key = var.psk0

  tunnel2_inside_cidr   = var.apipa_tunnel1_cidr
  tunnel2_preshared_key = var.psk1

  tags = {
    Name = "${var.project_name}-vpn-conn-inst0"
  }
}


######### Tunnel 1 ############

variable "apipa_tunnel0_cidr" {
  description = "CIDR of ToAzureInstance0 tunnel 1"
  type        = string
}

variable "psk0" {
  description = "PSK used for IKEv2 connection for ToAzureInstance0 tunnel 1"
  type        = string
}

######### Tunnel 2 ############

variable "apipa_tunnel1_cidr" {
  description = "CIDR of ToAzureInstance0 tunnel 2"
  type        = string
}

variable "psk1" {
  description = "PSK used for IKEv2 connection for ToAzureInstance0 tunnel 2"
  type        = string
}


##################################################################
# 5. Site-to-Site VPN Connection ToAzureInstance1 (BGP-enabled) ##
##################################################################

resource "aws_vpn_connection" "to_azure_instance1" {
  vpn_gateway_id      = aws_vpn_gateway.azure.id
  customer_gateway_id = aws_customer_gateway.ToAzureInstance1.id
  type                = "ipsec.1"

  static_routes_only = false

  tunnel1_inside_cidr   = var.apipa_tunnel2_cidr
  tunnel1_preshared_key = var.psk2

  tunnel2_inside_cidr   = var.apipa_tunnel3_cidr
  tunnel2_preshared_key = var.psk3

  tags = {
    Name = "${var.project_name}-vpn-conn-inst1"
  }
}


######### Tunnel 1 ############

variable "apipa_tunnel2_cidr" {
  description = "CIDR of ToAzureInstance1 tunnel 1"
  type        = string
}

variable "psk2" {
  description = "PSK used for IKEv2 connection for ToAzureInstance1 tunnel 1"
  type        = string
}

######### Tunnel 2 ############

variable "apipa_tunnel3_cidr" {
  description = "CIDR of ToAzureInstance1 tunnel 2"
  type        = string
}


variable "psk3" {
  description = "PSK used for IKEv2 connection for ToAzureInstance1 tunnel 2"
  type        = string
}



######################################################
##### 6. Startup Action -> Begin VPN Tunnels #########
######################################################
resource "null_resource" "start_vpn_inst0" {
  depends_on = [aws_vpn_connection.to_azure_instance0]

  provisioner "local-exec" {
    command = "aws ec2 start-vpn-connection --vpn-connection-id ${aws_vpn_connection.to_azure_instance0.id}"
  }
}

resource "null_resource" "start_vpn_inst1" {
  depends_on = [aws_vpn_connection.to_azure_instance1]

  provisioner "local-exec" {
    command = "aws ec2 start-vpn-connection --vpn-connection-id ${aws_vpn_connection.to_azure_instance1.id}"
  }
}


############################################################################################
# 7. Outputs for Tunnel Public IPs so that the Azure part can easily establish BGP routes ##
############################################################################################

output "tunnel1_ip_inst0" {
  description = "Public IP of tunnel1 to Azure instance0"
  value       = aws_vpn_connection.to_azure_instance0.tunnel1_address
}

output "tunnel2_ip_inst0" {
  description = "Public IP of tunnel2 to Azure instance0"
  value       = aws_vpn_connection.to_azure_instance0.tunnel2_address
}

output "tunnel1_ip_inst1" {
  description = "Public IP of tunnel1 to Azure instance1"
  value       = aws_vpn_connection.to_azure_instance1.tunnel1_address
}

output "tunnel2_ip_inst1" {
  description = "Public IP of tunnel2 to Azure instance1"
  value       = aws_vpn_connection.to_azure_instance1.tunnel2_address
}



