# --- Path for the SSH Private Key ---
variable "private_key_file_path" {
  description = "Local path where the generated private key (.pem) will be saved"
  type        = string
  default     = "./evilginx_key.pem"
}

# --- Path for the SSH Public Key ---
variable "public_key_path" {
  description = "Local path where the generated public key (.pub) will be saved"
  type        = string
  default     = "./evilginx_key.pub"
}

# --- Instance Configuration ---
variable "instance_type" {
  description = "The size of the EC2 instance"
  type        = string
  default     = "c7i-flex.large"
}

variable "disk_size" {
  description = "The size of the root volume in GB"
  type        = number
  default     = 30
}