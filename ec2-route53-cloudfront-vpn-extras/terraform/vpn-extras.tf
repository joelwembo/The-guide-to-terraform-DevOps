# VPN 
# resource "aws_vpc" "VPC-Azure" {
#  cidr_block = "192.168.0.0/16"
#  enable_dns_hostnames = true
#  enable_dns_support = true
#  enable_network_address_usage_metrics = true
#  lifecycle {
#    create_before_destroy = true
#  }
 
#  tags = {
#    Name = "VPC-Azure"
#  }
# }


# # Create Subnet 1 for vpc-azure ( VPN related)
# resource "aws_subnet" "prodxcloud-azure-subnet-1" {
#   vpc_id                  = aws_vpc.VPC-Azure.id
#   availability_zone       = "us-east-1a"
#   cidr_block              = "192.168.1.0/24"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "prodxcloud-azure-subnet-1"
#   }
# }
# # Create a  reserved Subnet 2
# # resource "aws_subnet" "prodxcloud-azure-subnet-2" {
# #   vpc_id                  = aws_vpc.VPC-Azure.id
# #   cidr_block              = "10.0.0.0/16"
# #   availability_zone       = "us-east-1b"
# #   map_public_ip_on_launch = true

# #   tags = {
# #     Name = "prodxcloud-azure-subnet-2"
# #   }
# # }

# # Create Customer Gatway ( VPN )

# module "cgw" {
#   source  = "terraform-aws-modules/customer-gateway/aws"
#   version = "~> 1.0"

#   name = "AWS-To-Azure"


#   customer_gateways = {
#     IP1 = {
#       bgp_asn    = 65112
#       ip_address = "20.248.118.159"
#     }
#   }

#   tags = {
#     Test = "maybe"
#   }
# }

# # output "customer_gateway_id" {
# #   value = module.cgw.aws_customer_gateway.this["IP1"]
  
# # }

# # Create Virtual Private Gateway
# resource "aws_vpn_gateway" "prodxcloud_vpn_gateway" {
#   vpc_id = aws_vpc.VPC-Azure.id
#   tags = {
#     Name = "My VPC-Azure VPN Gateway"
#   }

#   depends_on = [aws_vpc.VPC-Azure]
# }

# # aws vpn connection using terraform
# resource "aws_vpn_connection" "prodxcloud_vpn_connection" {
#   vpn_gateway_id = aws_vpn_gateway.prodxcloud_vpn_gateway.id
#   customer_gateway_id = "cgw-0553fbf7795d03de4"
#   type = "ipsec.1"

#   # routes {
#   #   destination_cidr_block = "172.16.0.0/24"
#   #   # vpn_gateway_id = aws_vpn_gateway.prodxcloud_vpn_gateway.id
#   # }

#   tags = {
#     Name = "xcloud_vpn_connection"
#   }


#   depends_on = [aws_vpn_gateway.prodxcloud_vpn_gateway]
# }
