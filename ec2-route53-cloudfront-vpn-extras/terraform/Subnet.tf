# (Optional) Because we already created subnets public and private attached to the VPC

# Creating Subnet 1
# resource "aws_subnet" "prodxcloud-subnet-1" {
#   vpc_id                  = aws_vpc.prodxcloud-vpc.id
#   availability_zone       = "us-east-1a"
#   cidr_block              = "10.0.0.0/16"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "prodxcloud-subnet-1"
#   }
# }
# # Creating reserved Subnet 2
# resource "aws_subnet" "prodxcloud-subnet-2" {
#   vpc_id                  = aws_vpc.prodxcloud-vpc.id
#   cidr_block              = "10.0.0.0/16"
#   availability_zone       = "us-east-1b"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "prodxcloud-subnet-2"
#   }
# }
