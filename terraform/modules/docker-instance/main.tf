data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name      = "name"
    values    = ["gitops_*"]
  }
  owners      = ["self"]
}

resource "aws_instance" "docker_instance" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.instance_type}"
  ebs_optimized = "${var.ebs_optimized}"
  vpc_security_group_ids = "${var.vpc_security_group_ids}"
  user_data = "${var.user_data}"
  availability_zone = "${var.availability_zone}"
  placement_group = "${var.placement_group}"
  key_name = "${var.key_name}"

  tags {
      Name  = "${var.tag_instance_name}"
      Owner = "${var.tag_instance_owner}"
      Group = "gitops-asg"
  }

# For spot only
#  provisioner "local-exec" {
#    command = "aws ec2 create-tags --resources ${self.spot_instance_id} --tags Key=Name,Value=gitops-instance-1"
#  }
}
