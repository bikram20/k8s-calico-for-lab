provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = var.shared_credentials_file
  profile                 = "default"
}

module "cali_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.username}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b"]
  public_subnets = ["10.0.0.0/24", "10.0.1.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false
  
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Terraform = "true"
  }
}

module "cali_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "cali_sg"
  description = "Security group for use in Calico clusers"

  vpc_id      = module.cali_vpc.vpc_id

  ingress_with_cidr_blocks = [
   {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      description = "open ssh"
      cidr_blocks = "0.0.0.0/0"
    },
   {
      from_port = "${var.ttyd_port}"
      to_port = "${var.ttyd_port}"
      protocol = "tcp"
      description = "ttyd"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  ingress_with_source_security_group_id = [
    {
      from_port = 0
      to_port = 0
      protocol = "-1"
      description = "this security group"
      source_security_group_id = module.cali_sg.this_security_group_id
    },
  ]

  egress_rules        = ["all-all"]
}


# 1 Master and 3 Worker nodes
module "cali_instances_masters" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "${var.username}-masters"
  instance_count         = 1

  ami                    = var.ubuntu_ami
  instance_type          = "t2.medium"
  vpc_security_group_ids = [module.cali_sg.this_security_group_id]
  key_name               = var.key_name
  subnet_id              = module.cali_vpc.public_subnets[0]
  associate_public_ip_address = true
  private_ip             = "10.0.0.10"
  source_dest_check      = false
  
  root_block_device = [
    {
      volume_size = 20
    },
  ]

  tags = {
    Name        = "${var.username}-master"
    NodeType    = "Master"
    Terraform   = "true"
  }
}

module "cali_instances_workers" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "${var.username}-workers"
  instance_count         = 3

  ami                    = var.ubuntu_ami
  instance_type          = "t2.small"
  vpc_security_group_ids = [module.cali_sg.this_security_group_id]
  key_name               = var.key_name
  subnet_id              = module.cali_vpc.public_subnets[0]
  associate_public_ip_address = true
  source_dest_check      = false
  private_ips            = ["10.0.0.11", "10.0.0.12", "10.0.0.20"]
  
  root_block_device = [
    {
      volume_size = 20
    },
  ]

  tags = {
    Name        = "${var.username}-worker"
    NodeType    = "worker"
    Terraform   = "true"
  }
}


# Calling Ansible
resource "null_resource" "ec2_cluster" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    ec2_cluster_ids = "${join(",", module.cali_instances_masters.id, module.cali_instances_workers.id)}"
  }

  # Make sure that the remote EC2 instance is up
  connection {
    type = "ssh"
    host = "${module.cali_instances_masters.public_ip[0]}"
    user = "ubuntu"
    port = 22
    private_key = file("${var.key_pair_file}")
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir $HOME/.k8s"
    ]
  }

  provisioner "file" {
    source      = "ansiblefiles/"
    destination = "$HOME/.k8s"
  }

  provisioner "remote-exec" {
    inline = [
      "cd $HOME/.k8s",
      "chmod 500 ${var.key_pair_file}",
      "ansible-playbook -i inventory -u ubuntu --private-key=${var.key_pair_file} --extra-vars \"ttyd_port=${var.ttyd_port} ttyd_password=${var.ttyd_password} ttyd_username=${var.username} ttyd_enable=${var.ttyd_enable}\" kube-cluster.yml",
    ]
  }

}

