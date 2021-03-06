data "aws_region" "current" {}

locals {
  availability_zone = "${data.aws_region.current.name}a"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name      = "name"
    values    = ["gitops_*"]
  }
  owners      = ["self"]
}

resource "aws_vpc" "dl-vpc" {
  cidr_block = "10.10.0.0/20"
}

resource "aws_internet_gateway" "dl-igw" {
  vpc_id = "${aws_vpc.dl-vpc.id}"

  tags {
    Name = "dl-igw"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.dl-vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.dl-igw.id}"
}

resource "aws_subnet" "dl-public-subnet-1" {
  vpc_id                  = "${aws_vpc.dl-vpc.id}"
  cidr_block              = "10.10.10.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${local.availability_zone}"
  tags = {
    Name =  "dl-public-subnet-1"
  }
}

resource "aws_subnet" "dl-private-subnet-1" {
  vpc_id     = "${aws_vpc.dl-vpc.id}"
  availability_zone = "${local.availability_zone}"
  cidr_block = "10.10.11.0/24"
  tags = {
    Name =  "dl-private-subnet-1"
  }
}

resource "aws_security_group" "dl-main-sg" {
  name        = "dl-main-sg"
  description = "Main SG"
  vpc_id      = "${aws_vpc.dl-vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port	= 0
    to_port	= 0
    protocol	= "-1"
    self	= true
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_placement_group" "dl-pg" {
  name     = "dl-pg"
  strategy = "cluster"
}

resource "aws_key_pair" "dl-key" {
  key_name   = "dl-key"
  public_key = "${var.public_key}"
}

resource "aws_instance" "dl-swarm-master" {
  count = 3
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.instance_type}"
  ebs_optimized = "${var.ebs_optimized}"
  vpc_security_group_ids = ["${aws_security_group.dl-main-sg.id}"]
  user_data = "${file("user_data.sh")}"
  availability_zone = "${local.availability_zone}"
  placement_group = "${aws_placement_group.dl-pg.id}"
  key_name        = "${aws_key_pair.dl-key.id}"
  subnet_id       = "${aws_subnet.dl-public-subnet-1.id}"
  associate_public_ip_address = true

  tags {
    Name = "dl-swarm-master-${count.index+1}"
    Owner = "talves"
    Group = "gitops-asg"
    Region = "${data.aws_region.current.name}"
  }

  provisioner "local-exec" {
    command = "cd ../../ansible; ansible-galaxy install -r requirements.yaml; ansible-playbook -i provisioned_host, -e host=provisioned_host -e ansible_ssh_host=${self.public_ip} docker_host.yaml"
  }

  provisioner "local-exec" {
    command = "bash -c '../../test.sh docker_host'"
  }
}

resource "aws_instance" "dl-swarm-worker" {
  count = 2
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.instance_type}"
  ebs_optimized = "${var.ebs_optimized}"
  vpc_security_group_ids = ["${aws_security_group.dl-main-sg.id}"]
  user_data = "${file("user_data.sh")}"
  availability_zone = "${local.availability_zone}"
  placement_group = "${aws_placement_group.dl-pg.id}"
  key_name        = "${aws_key_pair.dl-key.id}"
  subnet_id       = "${aws_subnet.dl-public-subnet-1.id}"
  associate_public_ip_address = true

  tags {
    Name = "dl-swarm-worker-${count.index+1}"
    Owner = "talves"
    Group = "gitops-asg"
    Region = "${data.aws_region.current.name}"
  }

  provisioner "local-exec" {
    command = "cd ../../ansible; ansible-galaxy install -r requirements.yaml; ansible-playbook -i provisioned_host, -e host=provisioned_host -e ansible_ssh_host=${self.public_ip} docker_host.yaml"
  }

  provisioner "local-exec" {
    command = "bash -c '../../test.sh docker_host'"
  }

# For spot only
#  provisioner "local-exec" {
#    command = "aws ec2 create-tags --resources ${self.spot_instance_id} --tags Key=Name,Value=gitops-instance-1"
#  }
}
