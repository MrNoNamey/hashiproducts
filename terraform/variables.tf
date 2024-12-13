variable "instance_type" {
  description = "The type of EC2 instance to create"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The Amazon Machine Image (AMI) ID to use for the instance"
  type        = string
  default     = "ami-0b5673b5f6e8f7fa7" # Amazon Linux 2 AMI for europe
}


variable "instance-region" {
  description = "Value of AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "instance-name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "Terraform-EC2-Docker-Instance"
}

variable "key-pair" {
  description = "Value of AWS SSH key-pair name"
  type        = string
  default     = "oei-key-pair"
}

variable "ec2_user_data" {
  description = "The user data script to install Docker on the EC2 instance"
  type        = string
  default     = <<-EOF
 #!/bin/bash
  
EOF
}
