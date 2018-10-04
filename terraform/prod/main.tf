provider "aws" {
  region = "us-east-2"
}

module "docker_linux" {
  source = "../modules/docker-linux"

  instance_type          = "${var.instance_type}"
  public_key             = "${var.public_key}"
  availability_zone      = "${var.availability_zone}"

  user_data = "${base64encode("touch /tmp/test-prod")}"
}
