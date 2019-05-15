variable "cloudformation_path" {
  description = "The root path to cloudformation templates"
  default = "cloudformation"
}

variable "userdata_path" {
  description = "The root path to userdata templates"
  default = "userdata"
}

variable "environment" {
  description = "The name of the environment associated with the host"
}

//variable "subnet" {
//  description = "The name of the VPC subnet in which to deploy the EC2 instance"
//}

variable "image_name" {
  description = "AWS image for Sling instance"
  default = "amzn2-ami-hvm-*"
}

variable "image_owner" {
  description = "AMI image owner (leave blank for current account)"
  default = "137112412989"
}

variable "image_os" {
  description = <<EOF
The operating system installed on the selected AMI. Valid values are:

  * al2     = Amazon Linux 2
  * ubuntu  = Ubuntu
EOF
  default = "al2"
}

variable "instance_type" {
  description = "AWS instance type for Sling"
  default = "t3.micro"
}

variable "sling_version" {
  description = "The major release version of Apache Sling to use"
  default = "10"
}

variable "sling_user" {
  description = "Username for Sling SSH user"
}

variable "ssh_key" {
  description = "Location of public key file for SSH access to host"
  default = "~/.ssh/id_rsa.pub"
}

variable "hosted_zone" {
  description = "Hosted zone identifier for DNS entry"
}