variable "public_key" {
	description = ""
}

variable "availability_zone" {
	default = "us-west-1a"
}

#locals {
#  availability_zone = "${concat(var.region, "a")}"
#}

variable "instance_type" {
	description = ""
}

variable "ebs_optimized" {
	description = ""
	default		= "true"
}

variable "user_data" {
	description = ""
}
