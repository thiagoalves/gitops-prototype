variable "public_key" {
	description = ""
}

variable "availability_zone" {
	description = ""
}

variable "tag_instance_name" {
	description = ""
}

variable "tag_instance_owner" {
	description = ""
}

variable "instance_type" {
	description = ""
}

variable "ebs_optimized" {
	description = ""
	default		= "true"
}

variable "vpc_security_group_ids" {
	type        = "list"
	description = ""
}

variable "user_data" {
	description = ""
}

variable "placement_group" {
	
}

variable "key_name" {
	
}
