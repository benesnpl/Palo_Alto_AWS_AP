data "aws_ami" "firewall" {
  most_recent                               = true
  owners                                    = ["aws-marketplace"]

  filter {
    name                                    = "name"
    values                                  = ["PA-VM-AWS-10.1.6-h6-7064e142-2859-40a4-ab62-8b0996b842e9*"]
  }
}

resource "aws_instance" "vm1" {
  ami                                       = data.aws_ami.firewall.id
  instance_type                             = var.instance_type
  availability_zone                         = var.azs[0]
  key_name                                  = "firewall"
  private_ip                                = var.mgm_ip_address1
  iam_instance_profile			                = aws_iam_instance_profile.ec2_profile.name
  subnet_id                                 = aws_subnet.MNG[0].id
  vpc_security_group_ids                    = [aws_security_group.MGMT_sg.id]
  disable_api_termination                   = false
  instance_initiated_shutdown_behavior      = "stop"
  ebs_optimized                             = true
  monitoring                                = false
  tags = {
                              #MODIFY REGION, E FOR EAST, W WEST
    Name                                    = join ("", [var.coid, "-AWS", "E", "PA01-A"])
    protera_type                            = "network appliance"
    protera_coid                            = var.coid
    protera_apid                            = "PA"
    protera_env                             = "PRD"
  }

  root_block_device {
    delete_on_termination                   = true
  }

}

resource "aws_instance" "vm2" {
  ami                                       = data.aws_ami.firewall.id
  instance_type                             = var.instance_type
  availability_zone                         = var.azs[0]
  key_name                                  = var.ssh_key_name
  private_ip                                = var.mgm_ip_address2
  iam_instance_profile			                = aws_iam_instance_profile.ec2_profile.name
  subnet_id                                 = aws_subnet.MNG[0].id
  vpc_security_group_ids                    = [aws_security_group.MGMT_sg.id]
  disable_api_termination                   = false
  instance_initiated_shutdown_behavior      = "stop"
  ebs_optimized                             = true
  monitoring                                = false
  depends_on                                = [aws_instance.vm1]
  tags = {
                              #MODIFY REGION, E FOR EAST, W WEST
    Name                                    = join ("", [var.coid, "-AWS", "E", "PA01-B"])
    protera_type                            = "network appliance"
    protera_coid                            = var.coid
    protera_apid                            = "PA"
    protera_env                             = "PRD"
  }

  root_block_device {
    delete_on_termination                   = true
  }
}

resource "aws_network_interface" "ha1" {
  subnet_id                                 = aws_subnet.ha.id
  private_ips                               = [var.ha_eni_1]
  security_groups                           = [aws_security_group.private_sg.id]
  depends_on                                = [aws_instance.vm1,aws_internet_gateway.main_igw,aws_ec2_transit_gateway.main_tgw,aws_eip.mng1]
  attachment {
    instance                                = aws_instance.vm1.id
	device_index                              = 1
  }
}

resource "aws_network_interface" "ha2" {
  subnet_id                                 = aws_subnet.ha.id
  private_ips                               = [var.ha_eni_2]
  security_groups                           = [aws_security_group.private_sg.id]
  depends_on                                = [aws_instance.vm1,aws_internet_gateway.main_igw,aws_ec2_transit_gateway.main_tgw,aws_eip.mng1]
  attachment {
    instance                                = aws_instance.vm2.id
	device_index                              = 1
  }
}


resource "aws_network_interface" "public1" {
  subnet_id                                 = aws_subnet.public[0].id
  private_ips                               = [var.public_eni_1]
  security_groups                           = [aws_security_group.public_sg.id]
  depends_on                                = [aws_instance.vm1,aws_internet_gateway.main_igw,aws_ec2_transit_gateway.main_tgw,aws_eip.mng1,aws_network_interface.ha2]	  

  attachment {
    instance                                = aws_instance.vm1.id
    device_index                            = 2
  }
}

resource "aws_network_interface" "private1" {
  subnet_id                                 = aws_subnet.Private[0].id
  private_ips                               = [var.private_eni_1]
  security_groups                           = [aws_security_group.private_sg.id]
  depends_on                                = [aws_instance.vm1,aws_internet_gateway.main_igw,aws_ec2_transit_gateway.main_tgw,aws_eip.mng1,aws_network_interface.public1]
  attachment {
    instance                                = aws_instance.vm1.id
	device_index                            = 3
  }
}
