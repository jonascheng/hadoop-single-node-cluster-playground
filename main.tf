module "ami" {
  source       = "github.com/terraform-community-modules/tf_aws_ubuntu_ami"
  region       = "${var.region}"
  distribution = "trusty"
  virttype     = "hvm"
  storagetype  = "ebs"
}

module "vpc" {
  source = "github.com/terraform-community-modules/tf_aws_vpc"
  name   = "${var.vpc_name}"
  cidr   = "10.0.0.0/16"
  private_subnets = "10.0.1.0/24,10.0.2.0/24"
  public_subnets  = "10.0.101.0/24,10.0.102.0/24"
  azs             = "${var.region}a,${var.region}c"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

module "sg" {
  source            = "github.com/drmobile/terraform-modules/sg-hadoop"
  name              = "${var.sg_name}"
  vpc_id            = "${module.vpc.vpc_id}"
  source_cidr_block = "0.0.0.0/0"  
}

resource "aws_instance" "hadoop" {
  count     = "1"
  ami       = "${module.ami.ami_id}"
  subnet_id = "${element(split(",", module.vpc.public_subnets), 0)}"
  vpc_security_group_ids = ["${module.sg.security_group_id}"]
  instance_type = "t2.micro"
  key_name = "jerry_fu"
  instance_initiated_shutdown_behavior = "terminate"
  user_data = "${file("scripts/bootstrap.sh")}"
  associate_public_ip_address = true
  tags {
    Name = "Hadoop"
  }
}
