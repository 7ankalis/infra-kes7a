# --- 1. DYNAMIC DATA LOOKUPS ---
data "aws_vpc" "default" { default = true }

data "aws_subnets" "default_subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Automatically find the latest Ubuntu 22.04 x86_64 image
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# --- 2. KEY GENERATION ---
resource "tls_private_key" "rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.rsa_key.private_key_pem
  filename        = var.private_key_file_path
  file_permission = "0400"
}

resource "aws_key_pair" "c2_key" {
  key_name   = "c2_key_dynamic"
  public_key = tls_private_key.rsa_key.public_key_openssh
}

# --- 3. DYNAMIC SECURITY GROUP ---
resource "aws_security_group" "c2_sg" {
  name        = "c2-firewall"
  description = "Allow SSH for C2 Server"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
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
}

# --- 4. EC2 INSTANCE ---
resource "aws_instance" "c2_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.c2_key.key_name
  vpc_security_group_ids = [aws_security_group.c2_sg.id]
  subnet_id              = data.aws_subnets.default_subnet.ids[0]

  associate_public_ip_address = true

  root_block_device {
    volume_size = var.disk_size
    volume_type = "gp3"
  }

  tags = { Name = "c2_server" }
}
