# print out the output of the public ip address of the ec2 instance
output "public_ip" {
  value = aws_instance.my_instance.public_ip
}
