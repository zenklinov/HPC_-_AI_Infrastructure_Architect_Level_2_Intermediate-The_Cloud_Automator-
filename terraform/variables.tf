variable "aws_region" {
  description = "AWS Region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 Instance Type (GPU enabled)"
  type        = string
  default     = "g4dn.xlarge" # T4 GPU
}

variable "project_name" {
  description = "Project name tag"
  type        = string
  default     = "ai-inference-server"
}
