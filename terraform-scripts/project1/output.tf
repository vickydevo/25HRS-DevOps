output "instance_ip" {
    description = "Instance Public IP"
    value = aws_instance.my_ec2.public_ip   
}

output "instance_id" {
    # description = "Instance ID"
    value = aws_instance.my_ec2.id   
}

output "instance_public_dns" {
    # description = "Public DNS"
    value = aws_instance.my_ec2.public_dns   
} 
output "key_pair_name" {
    # description = "Key Pair Name"
    value = aws_key_pair.my_local_key.key_name   
}
