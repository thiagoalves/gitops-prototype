variable "region" {
  description = ""
  default     = "${var.TF_VAR_AWS_REGION}"
}

variable "instance_type" {
  description = ""
  default     = "c5.large"
}

variable "public_key" {
  description = ""
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDC94OedAUtf5sh+zbX6icJrmR0tGCSI9oJCU4FdMMkXaFPemXdxpyB6qkJnx1sP5inGWBnmy2KdiqtGSQoHN0VW7TvYJzISv9xeMmhDvbWUSF+811Fhdvd7ZzFHClB2vqPjVwyIaTbBCIgus40XPcMnM7TwwSlTsKxKNzottZB+riIsqPGj7FGMcb17TlbWwfyMGyIjSb4f+wwBNF01ydedSJEo11CsZrQ/1B8BNplZrQG5LI7RmsXo6ayXT9Wmia/D0pd3DJT+f5SzsxtLaNC0H046r01IjNUIiockDFULnXLccs9zh4ICP0SnDzxQoTM0nOlolade1Dc9uDMlus1 banjo+thiago.alves@banjo"
}

variable "user_data" {
  description = ""
  default     = ""
}
