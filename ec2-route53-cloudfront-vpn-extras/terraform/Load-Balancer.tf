# Creating Load Balancer 

# resource "aws_lb" "PRODXCLOUD-Load-Balancer" {
#   name               = "PRODXCLOUD-Load-Balancer"
#   internal           = false
#   security_groups    = [aws_security_group.prodxcloud-SG.id]
#   subnets            = ["subnet-09f2df292f63e5390", "subnet-02eefb59769ac40c3"]
#   load_balancer_type = "application"
#   ip_address_type    = "ipv4"

#   # depends_on = [aws_subnet.prodxcloud_public_subnets, aws_security_group.prodxcloud-SG]
# }