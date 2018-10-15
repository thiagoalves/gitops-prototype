variable "public_key" {
	description = ""
}

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

variable "ips" {
	description = ""
	type = "map"
}
