variable "name" {
  description = "Base name used for the security group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "owner" {
  description = "Owner tag"
  type        = string
  default     = "devops"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to reach the stack. Restrict this to your IP in production (e.g. [\"YOUR_IP/32\"])."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
