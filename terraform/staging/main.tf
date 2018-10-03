provider "aws" {
  region = "us-west-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
}

data "aws_security_group" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
  name   = "default"
}

resource "aws_placement_group" "gitops-pg" {
  name     = "gitops-pg"
  strategy = "cluster"
}

resource "aws_key_pair" "gitops-key" {
  key_name   = "gitops-key"
  public_key = "${var.public_key}"
}

module "docker_instance_1" {
  source = "../modules/docker-instance"

  tag_instance_name  = "MY_INSTANCE_1"
  tag_instance_owner = "talves"

  placement_group = "${aws_placement_group.gitops-pg.id}"
  key_name        = "${aws_key_pair.gitops-key.id}"

  instance_type          = "${var.instance_type}"
  public_key             = "${var.public_key}"
  vpc_security_group_ids = "${var.vpc_security_group_ids}"
  availability_zone      = "${var.availability_zone}"

  user_data = "${base64encode("touch /tmp/test")}"
}

module "docker_instance_2" {
  source = "../modules/docker-instance"

  tag_instance_name  = "MY_INSTANCE_2"
  tag_instance_owner = "talves"

  placement_group = "${aws_placement_group.gitops-pg.id}"
  key_name        = "${aws_key_pair.gitops-key.id}"

  instance_type          = "${var.instance_type}"
  public_key             = "${var.public_key}"
  vpc_security_group_ids = "${var.vpc_security_group_ids}"
  availability_zone      = "${var.availability_zone}"

  user_data = "${base64encode("touch /tmp/test")}"
}
