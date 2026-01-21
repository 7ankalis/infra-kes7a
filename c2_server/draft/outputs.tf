output "instance_public_ip" {
  value = aws_instance.c2_server.public_ip
}

output "ssh_connection_command" {
  value = "ssh -i ${var.private_key_file_path} ubuntu@${aws_instance.c2_server.public_ip}"
}

output "alb_dns_name" {
  description = "Direct ALB address (should return 403)"
  value       = aws_lb.c2_alb.dns_name
}

output "cloudfront_domain_name" {
  description = "Point your beacons here"
  value       = aws_cloudfront_distribution.c2_distribution.domain_name
}
