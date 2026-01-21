variable "private_key_file_path" {
  description = "Local path where the generated private key (.pem) will be saved"
  type        = string
  default     = "./c2_key.pem"
}

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

variable "cloudfront_secret_header" {
  description = "Secret string used to authenticate CloudFront requests at the ALB"
  type        = string
  default     = "C2-Authorized-Front-Header-9988" 
}
