variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project" {
  description = "Name prefix for all resources"
  type        = string
  default     = "ts-devops-demo"
}

variable "key_name" {
  description = "Name of an existing EC2 key pair"
  type        = string
}

variable "my_ip" {
  description = "Your public IP in CIDR form, for example 203.0.113.10/32"
  type        = string
}
