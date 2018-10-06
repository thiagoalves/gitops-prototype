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
  availability_zone = "${var.availability_zone}"
  tags = {
    Name =  "dl-public-subnet-1"
  }
}

resource "aws_subnet" "dl-private-subnet-1" {
  vpc_id     = "${aws_vpc.dl-vpc.id}"
  availability_zone = "${var.availability_zone}"
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

resource "aws_instance" "dl_instance" {
  count = 2
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.instance_type}"
  ebs_optimized = "${var.ebs_optimized}"
  vpc_security_group_ids = ["${aws_security_group.dl-main-sg.id}"]
  user_data = "${var.user_data}"
  availability_zone = "${var.availability_zone}"
  placement_group = "${aws_placement_group.dl-pg.id}"
  key_name        = "${aws_key_pair.dl-key.id}"
  subnet_id       = "${aws_subnet.dl-public-subnet-1.id}"
  associate_public_ip_address = true

  tags {
    Name = "example-${count.index+1}"
    Owner = "talves"
    Group = "gitops-asg"
  }

# For spot only
#  provisioner "local-exec" {
#    command = "aws ec2 create-tags --resources ${self.spot_instance_id} --tags Key=Name,Value=gitops-instance-1"
#  }
}
