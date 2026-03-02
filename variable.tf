variable "aws_region" {
  description = "region"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "ami id"
  type        = string
  default     = "ami-0c02fb55956c7d316"
  
}

variable "instance_type" {
  description = "instance type"
  type        = string
  default     = "t2.micro"
}

variable "ec2_state" {
  description = "state ('started' or 'stopped')"
  type        = string
  default     = "stopped"
}