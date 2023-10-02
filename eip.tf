### Needed Public IP creation ###

resource "aws_eip" "mng1" {
  vpc                                       = true
  tags = {
    Name                                    = join("", [var.coid, "-", var.aws_region, "-management-eip"])
  }
  instance                                  = aws_instance.vm1.id
  associate_with_private_ip                 = var.mgm_ip_address1
  depends_on                                = [aws_instance.vm1,aws_internet_gateway.main_igw,aws_ec2_transit_gateway.main_tgw]
}

resource "aws_eip" "pub1" {
  vpc                                       = true
  tags = {
    Name                                    = join("", [var.coid, "-", var.aws_region, "-public-eip"])
  }
  network_interface                         = aws_network_interface.public1.id
  associate_with_private_ip                 = var.public_eni_1
  depends_on                                = [aws_instance.vm1,aws_internet_gateway.main_igw,aws_ec2_transit_gateway.main_tgw]
}
