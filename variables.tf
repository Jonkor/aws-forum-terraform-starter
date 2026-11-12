variable "aws_region" {
  description = "AWS region for all regional resources."
  type        = string
  default     = "us-west-1"
}

variable "project_name" {
  description = "Short name used in resource names."
  type        = string
  default     = "forum-v2"
}

variable "repo_url" {
  description = "HTTPS clone URL of the backend Git repository. It must be publicly accessible for this starter."
  type        = string
}

variable "env_parameter_name" {
  description = "Name of an SSM SecureString containing the app's complete .env file."
  type        = string
  default     = "/forum-v2/production/env"
}

variable "instance_type" {
  description = "EC2 instance type for the Auto Scaling Group."
  type        = string
  default     = "t3.small"
}

variable "min_size" {
  type    = number
  default = 2
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 4
}

variable "root_domain_name" {
  description = "Public Route 53 hosted zone"
  type = string
  default = "testaws.xyz"
}

variable "api_domain_name" {
  description = "Public API hostname"
  type = string
  default = "api.testaws.xyz"
}