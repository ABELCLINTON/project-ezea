provider "aws" {
  region = var.aws_region
}

# Networking Module
module "networking" {
  source       = "./modules/networking"
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
  subnet_cidr  = var.subnet_cidr
  aws_region   = var.aws_region
}

# EC2 Module
module "ec2" {
  source          = "./modules/ec2"
  project_name    = var.project_name
  vpc_id          = module.networking.vpc_id
  subnet_id       = module.networking.subnet_id
  ami_id          = var.ami_id
  instance_type   = var.instance_type
  public_key_path = var.public_key_path
}