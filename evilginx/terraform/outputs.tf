# The Public IP of the server
output "instance_public_ip" {
  description = "The public IP address of the Evilginx server"
  value       = aws_instance.evilginx_server.public_ip
}

# The Public DNS (useful for setting up your phishing domains)
output "instance_public_dns" {
  description = "The public DNS name of the server"
  value       = aws_instance.evilginx_server.public_dns
}

# A copy-paste ready SSH command
output "ssh_connection_command" {
  description = "Copy and paste this command to log into your server"
  value       = "ssh -i ${var.private_key_file_path} ubuntu@${aws_instance.evilginx_server.public_ip}"
}

# Reminder for DNS Setup
output "dns_setup_hint" {
  description = "Reminder for Evilginx DNS"
  value       = "Point your domain's nameservers to this IP: ${aws_instance.evilginx_server.public_ip}"
}