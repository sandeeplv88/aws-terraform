variable "instance_type" {
  default = "t3.medium"
}

variable "key_name" {
  description = "EC2 Key Pair name for SSH access"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for Jenkins (Amazon Linux 2 or Ubuntu)"
  type        = string
}

variable "sg_name" {
  description = "security group name for jenkins server"
  type        = set(string)
}