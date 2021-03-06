variable "cloudformation_path" {
  description = "The root path to cloudformation templates"
  default     = "cloudformation"
}

variable "template_path" {
  description = "The root path to userdata templates"
  default     = "templates"
}

variable "environment" {
  description = "The name of the environment associated with the host"
}

variable "vpc_default" {
  description = "Boolean value to indicate whether the matched VPC should be default for the region"
  default     = "true"
}

variable "vpc_tags" {
  type        = "map"
  description = "A map of tags to match on the VPC lookup"
  default     = {}
}

//variable "subnet" {
//  description = "The name of the VPC subnet in which to deploy the EC2 instance"
//}

variable "image_name" {
  description = "AWS image for Sling instance"
  default     = "amzn2-ami-hvm-2.0.????????-x86_64-gp2"
}

variable "image_owner" {
  description = "AMI image owner (leave blank for current account)"
  default     = "137112412989"
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

variable "ssh_user" {
  description = "Username for Sling SSH user"
}

variable "ssh_key" {
  description = "Public key file for SSH access to host"
  default = ""
}

variable "ssh_key_file" {
  description = "Location of public key file for SSH access to host"
  default = "~/.ssh/id_rsa.pub"
}

variable "hosted_zone" {
  description = "Hosted zone identifier for DNS entry"
}
