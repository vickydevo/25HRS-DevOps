variable "instance_type" {
    default = "t3.xlarge" # 4cpu, 16gb
    type = string
}

variable "ec2_ami" {
    default = "ami-0360c520857e3138f"
    type = string
}

variable "root_volume_size" {
    default = 20
    type = number
}
  
variable volume_type {
    default = "gp3"
    type = string
}

variable "ec2_name" {
    default = "observability-instance"
    type = string
}