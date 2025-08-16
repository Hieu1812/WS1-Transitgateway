terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
###### vpc 1
resource "aws_vpc" "public" {
  cidr_block = "172.12.1.0/24"
  tags = {
    Name = "test tf"
  }
}

resource "aws_subnet" "pb1" {
  vpc_id                  = aws_vpc.public.id
  cidr_block              = "172.12.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "publicsubnet"
  }
}

resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.public.id
  tags = {
    Name = "igw1"
  }
}


resource "aws_route_table" "rtbpublic" {
  vpc_id = aws_vpc.public.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw1.id
  }
  route {
    cidr_block         = "172.12.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.transit.id
  }
  tags = {
    Name = "publicrtb"
  }
}

resource "aws_route_table_association" "rtbasc" {
  subnet_id      = aws_subnet.pb1.id
  route_table_id = aws_route_table.rtbpublic.id
}

resource "aws_security_group" "sgpb1" {
  name        = "pb-sg"
  description = "ssh"
  vpc_id      = aws_vpc.public.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sgpb"
  }
}

resource "aws_instance" "ins1" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.pb1.id
  vpc_security_group_ids      = [aws_security_group.sgpb1.id]
  associate_public_ip_address = true
  key_name                    = "aws-keypair"
  tags = {
    Name = "tf"
  }
}

######  VPC 2
resource "aws_vpc" "private1" {
  cidr_block = "172.12.5.0/24"
  tags = {
    Name = "private1"
  }
}

resource "aws_subnet" "prv1" {
  vpc_id     = aws_vpc.private1.id
  cidr_block = "172.12.5.0/24"
  tags = {
    Name = "private1"
  }
}

resource "aws_route_table" "priv1rtb" {
  vpc_id = aws_vpc.private1.id
  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.transit.id
  }
  tags = {
    Name = "priv1rtb"
  }
}

resource "aws_route_table_association" "priv1rtbas" {
  route_table_id = aws_route_table.priv1rtb.id
  subnet_id      = aws_subnet.prv1.id
}
resource "aws_security_group" "priv1sg" {
  vpc_id      = aws_vpc.private1.id
  description = "ssh"
  name        = "priv1"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "prv1" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.prv1.id
  security_groups = [aws_security_group.priv1sg.id]
  key_name        = "aws-keypair"
}

# # VPC 3

resource "aws_vpc" "private2" {
  cidr_block = "172.12.3.0/24"
  tags = {
    Name = "priv1"
  }
}

resource "aws_subnet" "prv2" {
  vpc_id     = aws_vpc.private2.id
  cidr_block = "172.12.3.0/24"
  tags = {
    Name = "prv2"
  }
}

resource "aws_route_table" "priv2rtb" {
  vpc_id = aws_vpc.private2.id
  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.transit.id
  }
}

resource "aws_route_table_association" "priv2rtb" {
  route_table_id = aws_route_table.priv2rtb.id
  subnet_id      = aws_subnet.prv2.id
}

resource "aws_security_group" "priv2sg" {
  vpc_id      = aws_vpc.private2.id
  description = "ssh"
  name        = "priv2"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "prv2" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.prv2.id
  security_groups = [aws_security_group.priv2sg.id]
  key_name        = "aws-keypair"
  tags = {
    Name = "Priv2"
  }
}
# VPC 4

resource "aws_vpc" "priv3" {
  cidr_block = "172.12.0.6/24"
  tags = {
    Name = "priv3"
  }
}

resource "aws_subnet" "priv3" {
  vpc_id     = aws_vpc.priv3.id
  cidr_block = "172.12.0.6/24"
  tags = {
    Name = "priv3"
  }
}

resource "aws_route_table" "rtbpriv3" {
  vpc_id = aws_vpc.priv3.id
  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.transit.id
  }
}

resource "aws_route_table_association" "rtbasspriv3" {
  subnet_id      = aws_subnet.priv3.id
  route_table_id = aws_route_table.rtbpriv3.id
}

resource "aws_security_group" "priv3sg" {
  vpc_id      = aws_vpc.priv3.id
  description = "ssh"
  name        = "priv3"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "priv3" {
  ami             = data.aws_ami.ubuntu.id
  security_groups = [aws_security_group.priv3sg.id]
  subnet_id       = aws_subnet.priv3.id
  key_name        = "aws-keypair"
  tags = {
    Name = "priv3"
  }
}

# transitgateway

resource "aws_ec2_transit_gateway" "transit" {
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "pb" {
  vpc_id             = aws_vpc.public.id
  subnet_ids         = [aws_subnet.pb1.id]
  transit_gateway_id = aws_ec2_transit_gateway.transit.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "priv1" {
  vpc_id             = aws_vpc.private1.id
  subnet_ids         = [aws_subnet.prv1.id]
  transit_gateway_id = aws_ec2_transit_gateway.transit.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "priv2" {
  vpc_id             = aws_vpc.private2.id
  subnet_ids         = [aws_subnet.prv2.id]
  transit_gateway_id = aws_ec2_transit_gateway.transit.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "priv3" {
  vpc_id             = aws_vpc.priv3.id
  subnet_ids         = [aws_subnet.priv3.id]
  transit_gateway_id = aws_ec2_transit_gateway.transit.id
}

resource "aws_ec2_transit_gateway_route_table" "transitgwrtb" {
  transit_gateway_id = aws_ec2_transit_gateway.transit.id
  tags = {
    Name = "transitgwrtb"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "transitgwrtbass" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.pb.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.transitgwrtb.id
}

resource "aws_ec2_transit_gateway_route_table_association" "transitgwrtbpriv" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.priv1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.transitgwrtb.id
}

resource "aws_ec2_transit_gateway_route_table_association" "transitgwrtbpriv2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.priv2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.transitgwrtb.id
}

resource "aws_ec2_transit_gateway_route_table_association" "transitgwrtbpriv3" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.priv3.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.transitgwrtb.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "transitgwrtbpro" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.transitgwrtb.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.pb.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "transitgwrtbprivpro" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.priv1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.transitgwrtb.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "transitgwrtbpriv2pro" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.priv2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.transitgwrtb.id
}
resource "aws_ec2_transit_gateway_route_table_propagation" "transitgwrtbpriv3pro" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.priv3.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.transitgwrtb.id
}