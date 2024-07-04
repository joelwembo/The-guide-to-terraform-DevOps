# AWS Spot Instance request and instance

# Request a spot instance at $0.03
# resource "aws_spot_instance_request" "cheap_ec2" {
#   ami           = "ami-1234"
#   spot_price    = "0.03"
#   instance_type = "c4.xlarge"

#   tags = {
#     Name = "Cheap ec2"
#   }
# }
# Apply Spot instance
# resource "aws_instance" "spot_instance" {
#   ami                         = "ami-0eaf7c3456e7b5b68" # Example AMI ID, replace with your AMI
#   instance_type               = "t2.micro"
#   key_name                    = var.instance_keyName
#   security_groups = ["${aws_security_group.prodxcloud-SG.id}", "${aws_security_group.prodxcloud-SG.id}"]
#   subnet_id = aws_subnet.prodxcloud_public_subnets.id

#    tags = {
#     Name = "SpotInstanceTF"
#   }

# }
