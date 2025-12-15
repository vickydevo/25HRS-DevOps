# create a key pair
resource aws_key_pair my_local_key {
  key_name   = "terra-key"
  public_key = file("terra-key.pub")
}

# vpc and security group 
resource "aws_default_vpc" "N_default" {
  tags = {
    Name = "Default VPC"
  }
}


resource aws_security_group my_sg {
    name = "Sg-for-terraform"
    description = "Security group for terraform ec2 instance"
    vpc_id = aws_default_vpc.N_default.id 

    #inbound rules
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow SSH traffic"
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTP traffic"
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    #outbound rules
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "Sg-for-terraform" 
    }
}

# EC2 instance

resource "aws_instance" "my_ec2" {
    instance_type = var.instance_type
    security_groups = [aws_security_group.my_sg.name]
    ami = var.ec2_ami  # ubuntu 
    key_name = aws_key_pair.my_local_key.key_name
    user_data = file("miniInstall.sh")
    root_block_device {
        volume_size = var.root_volume_size
        volume_type = var.volume_type
        delete_on_termination = true
    }

    tags = {
        Name = var.ec2_name
        Environment = "Dev" 
    }
    

}

