
# Creating Target Group
# resource "aws_lb_target_group" "PRODXCLOUD-TG" {
#   health_check {
#     interval            = 10
#     path                = "/"
#     protocol            = "HTTP"
#     timeout             = 5
#     healthy_threshold   = 5
#     unhealthy_threshold = 2
#   }
#   name     = "TG"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.prodxcloud-vpc.id

#   tags = {
#     Name = "prodxcloud-TG"
#   }

#   depends_on = [ aws_security_group.prodxcloud-SG ]
# }