variable "aws_region" {
	default = "us-east-1"
}

#MAKE SURE TO UPDATE REGION BASED ON ABOVE SELECTION
variable "azs" {
	type = list
	default = ["us-east-1a"]
}

#MUST MATCH WITH ABOVE
variable "azs-ha" {
	default = "us-east-1a"
}

#CIDR FOR HUB ACCOUNT
variable "vpc_cidr" {
	default = "10.160.236.0/24"
}

variable "coid" {
	default = "bauh"
}

#m5.xlarge for VM-100 and VM-300
#m5.2xlarge for VM-500
variable "instance_type" {
	default = "m5.xlarge"
}

variable "rules_inbound_public_sg" {
  default = [
    {
      port = 0
      proto = "-1"
      cidr_block = ["0.0.0.0/0"]
    }
    ]
}

variable "rules_outbound_public_sg" {
  default = [
    {
      port = 0
      proto = "-1"
      cidr_block = ["0.0.0.0/0"]
    }
    ]
}

variable "rules_inbound_private_sg" {
  default = [
    {
      port = 0
      proto = "-1"
      cidr_block = ["10.0.0.0/8","192.168.0.0/16","172.16.0.0/12","100.70.0.0/15"]
    }
    ]
}

variable "rules_outbound_private_sg" {
  default = [
    {
      port = 0
      proto = "-1"
      cidr_block = ["0.0.0.0/0"]
    }
    ]
}

variable "rules_inbound_mgmt_sg" {
  default = [
  
    {
      port = 0
      proto = "-1"
      cidr_block = ["10.0.0.0/8","192.168.0.0/16","172.16.0.0/12","100.70.0.0/15","52.147.201.44/32","207.223.34.132/32"]
    }
    ]
}

variable "rules_outbound_mgmt_sg" {
  default = [
    {
      port = 0
      proto = "-1"
      cidr_block = ["0.0.0.0/0"]
    }
    ]
}

variable "subnets_cidr_public" {
	type = list
	default = ["10.160.236.128/25"]
}

variable "subnets_cidr_private" {
	type = list
	default = ["10.160.236.16/28"]
}

variable "subnets_cidr_mng" {
	type = list
	default = ["10.160.236.0/28"]
}

variable "subnets_cidr_tgw" {
	type = list
	default = ["10.160.236.48/28"]
}

variable "subnets_cidr_ha" {
	default = "10.160.236.32/28"
}

variable "mgm_ip_address1" {
	default = "10.160.236.5"
}

variable "mgm_ip_address2" {
	default = "10.160.236.6"
}

#FLOAT IP FOR EXTERNAL INTERFACE
variable "public_eni_1" {
	default = "10.160.236.132"
}

#FLOAT IP FOR INTERNAL INTERFACE
variable "private_eni_1" {
	default = "10.160.236.20"
}

variable "ha_eni_1" {
	default = "10.160.236.36"
}

variable "ha_eni_2" {
	default = "10.160.236.37"
}

variable "aws_access_key_id" {
	default = null
}

variable "aws_secret_access_key" {
	default = null
}

#OAKBROOK VPN TUNNEL IP
variable "il_external" {
	default = "207.223.34.132"
}

variable "ssh_key_name" {
	default = "firewall"
}
