output "ALB_public_dns" {
  value       = "http://${aws_lb.nginx.dns_name}"
  description = "ALB public DNS"
}

output "aws_instance1_public_ip" {
  value       = aws_instance.nginx1.public_ip
  description = "Public IP for instance 1"
}

output "aws_instance2_public_ip" {
  value       = aws_instance.nginx2.public_ip
  description = "Public IP for instance 2"
}