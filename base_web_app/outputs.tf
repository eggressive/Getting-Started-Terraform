output "aws_instance_public_dns" {
  value       = "http://${aws_instance.nginx1.public_dns}"
  description = "public DNS for the instance"
}

output "aws_instance_public_ip" {
  value       = aws_instance.nginx1.public_ip
  description = "Public IP for the instance"
}