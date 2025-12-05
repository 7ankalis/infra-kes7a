# outputs.tf

output "instance_public_ip" {
  description = "The public IP address of the newly created EC2 instance"
  value       = aws_instance.evilginx_server.public_ip
}

output "instance_public_dns" {
  description = "The public DNS name of the newly created EC2 instance"
  value       = aws_instance.evilginx_server.public_dns
}

output "ssh_command_ready" {
  description = "Suggested SSH command to connect to the instance (User: ubuntu)"
  # Uses the correct key file and the public DNS name
  value = "ssh -i ${var.private_key_file_path} ubuntu@${aws_instance.evilginx_server.public_dns}"
}
