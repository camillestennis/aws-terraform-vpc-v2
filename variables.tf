variable "my_ip" {
  description = "Your public IP for SSH access, in CIDR notation"
  type        = string
}

variable "environment" {
  description = "Environment tag applied to all resources"
  type        = string
  default     = "portfolio"
}

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-west-1"
}