# The Public IP of the server
output "instance_public_ip" {
  description = "The public IP address of the C2 server"
  value       = aws_instance.c2_server.public_ip
}

# The Public DNS
output "instance_public_dns" {
  description = "The public DNS name of the server"
  value       = aws_instance.c2_server.public_dns
}

# A copy-paste ready SSH command
output "ssh_connection_command" {
  description = "Copy and paste this command to log into your server"
  value       = "ssh -i ${var.private_key_file_path} ubuntu@${aws_instance.c2_server.public_ip}"
}
