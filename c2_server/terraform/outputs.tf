output "instance_public_ip" {
  value = aws_instance.c2_server.public_ip
}

output "instance_public_dns" {
  description = "The public DNS of the C2 server"
  value       = aws_instance.c2_server.public_dns
}

output "ssh_connection_command" {
  value = "ssh -i ${var.private_key_file_path} ubuntu@${aws_instance.c2_server.public_ip}"
}

output "ssh_connection_dns_command" {
  description = "SSH connection string using the EC2 Public DNS"
  value       = "ssh -i ${var.private_key_file_path} ubuntu@${aws_instance.c2_server.public_dns}"
}

output "alb_dns_name" {
  description = "Direct ALB address (should return 403)"
  value       = aws_lb.c2_alb.dns_name
}

output "cloudfront_domain_name" {
  description = "Point your beacons here"
  value       = aws_cloudfront_distribution.c2_distribution.domain_name
}
