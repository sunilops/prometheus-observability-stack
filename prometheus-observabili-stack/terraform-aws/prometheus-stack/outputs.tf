output "instance_public_ip" {
  description = "Public IP address(es) of the provisioned instance(s)"
  value       = module.ec2.instance_public_ip
}

output "instance_public_dns" {
  description = "Public DNS name(s) of the provisioned instance(s)"
  value       = module.ec2.instance_public_dns
}

output "instance_state" {
  description = "State of the provisioned instance(s)"
  value       = module.ec2.instance_state
}

output "security_group_id" {
  description = "ID of the security group applied to the instance(s)"
  value       = module.security_group.security_group_id
}
