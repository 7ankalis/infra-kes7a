# --- 1. LOCAL KEY GENERATION (for the .pem file) ---
# Generate a new RSA private key locally
resource "tls_private_key" "rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Write the private key to a local file (evilginx_key.pem)
resource "local_file" "private_key" {
  content  = tls_private_key.rsa_key.private_key_pem
  filename = var.private_key_file_path
  # Ensure the file has appropriate permissions (read-only for owner)
  file_permission = "0400"
}

# Write the public key to a local file (evilginx_key.pub)
resource "local_file" "public_key" {
  content  = tls_private_key.rsa_key.public_key_pem
  filename = var.public_key_path
}

# --- 2. AWS KEY PAIR RESOURCE (FIXED REFERENCE) ---
# Create the key pair in AWS using the generated public key content
resource "aws_key_pair" "evilginx_key" {
  key_name = "evilginx_key"
  # FIX: Reference the public key content directly from the generator resource
  public_key = tls_private_key.rsa_key.public_key_openssh
}

# --- 3. DATA SOURCES (VPC and Subnet lookup) ---
# Find the default VPC
data "aws_vpc" "default" {
  default = true
}

# Find the IDs of subnets in the default VPC (FIXED BLOCK: aws_subnets)
data "aws_subnets" "default_subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# --- 4. AWS EC2 INSTANCE RESOURCE ---
resource "aws_instance" "evilginx_server" {
  # Configuration based on your requirements
  ami                    = "ami-0fa91bc90632c73c9"
  instance_type          = "c7i-flex.large" # 2 vCPUs and 4 GiB of RAM
  key_name               = aws_key_pair.evilginx_key.key_name
  vpc_security_group_ids = [var.security_group_id]

  # Select the first available subnet found (FIXED REFERENCE: aws_subnets)
  subnet_id = data.aws_subnets.default_subnet.ids[0]
  # Assign a public IP address
  associate_public_ip_address = true

  # Root Block Device (Storage)
  root_block_device {
    volume_size           = 30    # GiB
    volume_type           = "gp3" # General Purpose SSD
    delete_on_termination = true
  }

  # Tags for identification
  tags = {
    Name    = "evilginx_server"
    Purpose = "Honeypot"
  }
}

