output "instance_public_ip" {
  description = "Public IP addresses of the created instance(s)"
  value       = aws_instance.prometheus_stack[*].public_ip
}

output "instance_public_dns" {
  description = "Public DNS names of the created instance(s)"
  value       = aws_instance.prometheus_stack[*].public_dns
}

output "instance_state" {
  description = "State of the created instance(s)"
  value       = aws_instance.prometheus_stack[*].instance_state
}

output "instance_id" {
  description = "IDs of the created instance(s)"
  value       = aws_instance.prometheus_stack[*].id
}
