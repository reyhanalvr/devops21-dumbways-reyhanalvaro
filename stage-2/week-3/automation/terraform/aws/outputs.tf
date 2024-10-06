output "instance_ids" {
  description = "The IDs of the EC2 instances"
  value       = [aws_instance.ubuntu.id, aws_instance.debian.id]
}

output "instance_public_ips" {
  description = "The public IPs of the EC2 instances"
  value       = [aws_instance.ubuntu.public_ip, aws_instance.debian.public_ip]
}
