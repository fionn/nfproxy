locals {
  common_tags = {
    Env     = "production"
    Project = "nfproxy"
  }
  template_map = {
    proxy_destination_address = var.proxy_destination_address
    proxy_destination_port    = var.proxy_destination_port
    proxy_source_port         = var.proxy_source_port
  }
}

resource "aws_security_group" "nfproxy" {
  name = "nfproxy"

  ingress {
    description      = "Allow pings"
    from_port        = 8 # ICMP type number
    to_port          = 0 # ICMP code
    protocol         = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allow inbound SSH connections"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description      = "Allow all outbound traffic for provisioning and upgrading"
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "Inbound traffic to proxy"
    from_port   = var.proxy_source_port
    to_port     = var.proxy_source_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound traffic to proxy"
    from_port   = var.proxy_destination_port
    to_port     = var.proxy_destination_port
    protocol    = "tcp"
    cidr_blocks = [join("/", [var.proxy_destination_address, 32])]
  }

  tags = local.common_tags
}

data "aws_ami" "fedora" {
  owners      = ["125523088429"] # Fedora
  most_recent = true

  filter {
    name   = "name"
    values = ["Fedora-Cloud-Base-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_eip" "nfproxy" {
  instance = aws_instance.nfproxy.id
  tags     = local.common_tags
}

data "cloudinit_config" "nfproxy" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.root}/data/init.yaml", local.template_map)
  }
}

resource "aws_instance" "nfproxy" {
  ami                    = data.aws_ami.fedora.id
  instance_type          = "t2.micro" # Needs to be greater than t2.nano.
  user_data              = data.cloudinit_config.nfproxy.rendered
  vpc_security_group_ids = [aws_security_group.nfproxy.id]
  key_name               = aws_key_pair.local.key_name
  tags                   = merge(local.common_tags, { "Name" = "nfproxy" })
}

resource "aws_key_pair" "local" {
  key_name   = "local_key"
  public_key = file("~/.ssh/id_ed25519.pub")
  tags       = local.common_tags
}
