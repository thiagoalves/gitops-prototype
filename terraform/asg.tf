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

data "aws_ami" "ubuntu" {
  most_recent = true
  name_regex  = "^ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-\\d+"
  owners      = ["099720109477"]
}

resource "aws_placement_group" "gitops-pg" {
  name     = "gitops-pg"
  strategy = "cluster"
}

resource "aws_key_pair" "gitops-key" {
  key_name   = "gitops-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDC94OedAUtf5sh+zbX6icJrmR0tGCSI9oJCU4FdMMkXaFPemXdxpyB6qkJnx1sP5inGWBnmy2KdiqtGSQoHN0VW7TvYJzISv9xeMmhDvbWUSF+811Fhdvd7ZzFHClB2vqPjVwyIaTbBCIgus40XPcMnM7TwwSlTsKxKNzottZB+riIsqPGj7FGMcb17TlbWwfyMGyIjSb4f+wwBNF01ydedSJEo11CsZrQ/1B8BNplZrQG5LI7RmsXo6ayXT9Wmia/D0pd3DJT+f5SzsxtLaNC0H046r01IjNUIiockDFULnXLccs9zh4ICP0SnDzxQoTM0nOlolade1Dc9uDMlus1 banjo+thiago.alves@banjo"
}

resource "aws_launch_template" "gitops-lt" {
  name_prefix = "gitops-instance-"
  image_id = "${data.aws_ami.ubuntu.id}"
  instance_type = "c5.large"

#  block_device_mappings {
#    device_name = "/dev/sda1"
#    ebs {
#      volume_size = 20
#    }
#  }

#  disable_api_termination = true

  ebs_optimized = true

#  iam_instance_profile {
#    name = "central-ansible"
#  }

  instance_market_options {
    market_type = "spot"
  }

  key_name = "${aws_key_pair.gitops-key.id}"

#  network_interfaces {
#    associate_public_ip_address = false
#  }

  placement {
    availability_zone = "us-west-1a"
  }

  vpc_security_group_ids = ["sg-606b5507"]

  tag_specifications {
    resource_type = "instance"
    tags {
      Name = "gitops-instance-x" 
      Owner = "talves"
      Group = "gitops-asg"
    }
  }

  user_data = "${base64encode("touch /tmp/test")}"

  tags {
    Owner = "talves"
  }
}

resource "aws_autoscaling_group" "gitops-asg" {
  availability_zones = ["us-west-1a"]
  desired_capacity = 3
  max_size = 3
  min_size = 3
  placement_group = "${aws_placement_group.gitops-pg.id}"
  launch_template = {
    id = "${aws_launch_template.gitops-lt.id}"
    version = "$$Latest"
  }
}
