# These variables are auto-generated and will change for every user

variable "username" {
  description = "user name - to create the vpc with the name"
}

variable "key_name" {
  description = "key name - created separately and must exist in AWS account"
}

variable "key_pair_file" {
  description = "path to key file pem"
}

variable "ubuntu_ami" {
  description = "Updated Ubuntu 18.04 kube ready AMI"
}

variable "ttyd_enable" {
  description = "ttyd to be enabled - yes or no"
}
variable "ttyd_password" {
  description = "ttyd password to use"
}
variable "ttyd_port" {
  description = "ttyd port to use"
}

# These variables are fixed

variable "shared_credentials_file" {
  type      = string
  default   = "$HOME/.aws/credentials"
}


variable "aws_region" {
  description = "The AWS region to deploy into"
  default     = "us-west-2"
}

