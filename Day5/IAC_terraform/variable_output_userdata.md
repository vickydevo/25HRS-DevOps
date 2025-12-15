# Terraform: variables.tf and outputs.tf

Place the following two files in the same Terraform module directory.

## variables.tf
```hcl
variable "instance_type" {
    default = "t3.micro"
    type = string
}

variable "ec2_ami" {
    default = "ami-0360c520857e3138f"
    type = string
}

variable root_volume_size {
    default = 8
    type = number
}
  
variable volume_type {
    default = "gp3"
    type = string
}
```

Save as: variables.tf

## outputs.tf
```hcl
output "instance_ip" {
    description = "Instance Public IP"
    value = aws_instance.my_ec2.public_ip   
}

output "instance_id" {
    description = "Instance ID"
    value = aws_instance.my_ec2.id   
}

output "instance_public_dns" {
    description = "Public DNS"
    value = aws_instance.my_ec2.public_dns   
} 

```

Save as: outputs.tf

## User Data Script (InstallNginx.sh)
```bash
#!/bin/bash
sudo apt update -y
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
echo "<h1>Nginx installed and started successfully by Terraform.</h1>" | sudo tee /var/www/html/index.html
```

Save as: InstallNginx.sh

### Usage in EC2 Resource
```hcl
resource "aws_instance" "my_ec2" {
    # ... other configuration ...
    user_data = file("InstallNginx.sh")
}
```

This script will install and start Nginx automatically when the EC2 instance launches.

## Quick usage
- Run `terraform init`
- Run `terraform plan` (to preview) or `terraform apply` (to apply) — outputs will be shown after apply.
- To force recreation of the EC2 instance, run:
    - `terraform taint aws_instance.my_ec2`
    - then `terraform apply`
- Taint marks the resource as needing replacement so Terraform will destroy and recreate it on the next apply.

That's it. Place these files in your module and adjust variables/defaults as needed.