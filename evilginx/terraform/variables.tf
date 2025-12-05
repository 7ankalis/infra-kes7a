# --- Variables for Security Group ID ---
variable "security_group_id" {
  description = "The ID of the existing security group (launch-wizard-4)"
  type        = string
  # Your specified security group ID
  default = "sg-0f5029e47217fa1a8"
}

# --- Variables for Key Pair Files ---
variable "private_key_file_path" {
  description = "Path where the private key (evilginx_key.pem) will be saved"
  type        = string
  default     = "evilginx_key.pem"
}

variable "public_key_path" {
  description = "Path where the public key will be saved (used by aws_key_pair)"
  type        = string
  default     = "evilginx_key.pub"
}
