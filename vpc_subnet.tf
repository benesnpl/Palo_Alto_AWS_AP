# Create a VPC - Subnets

resource "aws_vpc" "main_vpc" {
  cidr_block       					            = var.vpc_cidr
  tags = {
    Name                                        =  join("", [var.coid, "-", var.aws_region, "-vpc00-fw"])
  }
}

resource "aws_subnet" "public" {
  count                                         = length(var.subnets_cidr_public)
  vpc_id                                        = aws_vpc.main_vpc.id
  cidr_block                                    = element(var.subnets_cidr_public,count.index)
  availability_zone                             = element(var.azs,count.index)
  map_public_ip_on_launch                       = true
  tags = {
    Name                                        = join("", [var.coid, "-", var.aws_region, "-Public", "-", "AZ${count.index+1}"])
  }
}

resource "aws_subnet" "Private" {
  count                                         = length(var.subnets_cidr_private)
  vpc_id                                        = aws_vpc.main_vpc.id
  cidr_block                                    = element(var.subnets_cidr_private,count.index)
  availability_zone                             = element(var.azs,count.index)
  map_public_ip_on_launch                       = true
  tags = {
    Name                                        = join("", [var.coid, "-", var.aws_region, "-Private", "-", "AZ${count.index+1}"])
  }
}

resource "aws_subnet" "MNG" {
  count                                         = length(var.subnets_cidr_mng)
  vpc_id                                        = aws_vpc.main_vpc.id
  cidr_block                                    = element(var.subnets_cidr_mng,count.index)
  availability_zone                             = element(var.azs,count.index)
  map_public_ip_on_launch                       = true
  tags = {
    Name                                        = join("", [var.coid, "-", var.aws_region, "-Management", "-", "AZ${count.index+1}"])
  }
}

resource "aws_subnet" "TGW" {
  count                                         = length(var.subnets_cidr_tgw)
  vpc_id                                        = aws_vpc.main_vpc.id
  cidr_block                                    = element(var.subnets_cidr_tgw,count.index)
  availability_zone                             = element(var.azs,count.index)
  map_public_ip_on_launch                       = true
  tags = {
    Name                                        = join("", [var.coid, "-", var.aws_region, "-TGW", "-", "AZ${count.index+1}"])
  }
}

resource "aws_subnet" "ha" {
  vpc_id                                        = aws_vpc.main_vpc.id
  cidr_block                                    = var.subnets_cidr_ha
  availability_zone                             = var.azs-ha
  map_public_ip_on_launch                       = false
  tags = {
    Name                                        = join("", [var.coid, "-", var.aws_region, "-HA"])
  }
}
