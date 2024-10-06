provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "ubuntu" {
  ami           = var.ubuntu_ami_id
  instance_type = var.instance_type
  key_name      = var.key_name 
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  subnet_id = var.subnet_id

  tags = {
    Name = "Ubuntu-Server"
  }
}

resource "aws_instance" "debian" {
  ami           = var.debian_ami_id
  instance_type = var.instance_type
  key_name      = var.key_name 
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  subnet_id     = var.subnet_id

  tags = {
    Name = "Debian-Server"
  }
}

resource "aws_eip" "ubuntu_eip" {
  instance = aws_instance.ubuntu.id
}

resource "aws_eip" "debian_eip" {
  instance = aws_instance.debian.id
}

data "aws_availability_zones" "available" {}

resource "aws_ebs_volume" "ubuntu_storage" {
  count             = 1
  availability_zone = element(data.aws_availability_zones.available.names, 0) 
  size              = var.block_storage_size
}

resource "aws_ebs_volume" "debian_storage" {
  count             = 1
  availability_zone = element(data.aws_availability_zones.available.names, 0) 
  size              = var.block_storage_size
}

resource "aws_volume_attachment" "ubuntu_attach" {
  count       = 1
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ubuntu_storage[0].id
  instance_id = aws_instance.ubuntu.id
}

resource "aws_volume_attachment" "debian_attach" {
  count       = 1
  device_name = "/dev/sdi"
  volume_id   = aws_ebs_volume.debian_storage[0].id
  instance_id = aws_instance.debian.id
}

# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"
# }

# resource "aws_subnet" "main" {
#   # vpc_id            = var.vpc_id
#   cidr_block        = "172.31.48.0/20"
#   availability_zone = "${var.aws_region}a"
# }

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  # vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" // ALLOW ALL BANG
    cidr_blocks  = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" // ALLOW ALL BANG
    cidr_blocks  = ["0.0.0.0/0"]
  }
}