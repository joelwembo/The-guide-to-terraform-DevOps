# Define security group
resource "aws_security_group" "eks_sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id = aws_vpc.my_vpc.id
  # Define your security group rules here

  
   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  
    # prefix_list_ids = [aws_vpc_endpoint.my_endpoint.prefix_list_id]
  }

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  
    # prefix_list_ids = [aws_vpc_endpoint.my_endpoint.prefix_list_id]
  }

  tags = {
    Name = "allow_tls"
  }
}


# resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
#   security_group_id = aws_security_group.eks_sg.allow_tls.id
#   cidr_ipv4         = aws_vpc.my_vpc.cidr_block
#   from_port         = 443
#   ip_protocol       = "tcp"
#   to_port           = 443
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
#   security_group_id = aws_security_group.eks_sg.allow_tls.id
#   cidr_ipv6         = aws_vpc.my_vpc.ipv6_cidr_block
#   from_port         = 443
#   ip_protocol       = "tcp"
#   to_port           = 443
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
#   security_group_id = aws_security_group.eks_sg.allow_tls.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }


# Define ALB for React application
resource "aws_lb" "my_load_balancer" {
  name               = "prodxcloud-store"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.eks_sg.id]
  # subnets            = [aws_subnet.public-us-east-1a.id]
  subnets            = [aws_subnet.public-us-east-1a.id, aws_subnet.public-us-east-1b.id]  # Use subnets from different Availability Zones
}


# Define ALB target group
resource "aws_lb_target_group" "my_target_group" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
}

# Define ALB listener
resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}



# # Define Kubernetes deployment and service for React application
# resource "kubernetes_deployment" "prodxcloud_store_deployment" {
#   metadata {
#     name = "prodxcloud-store"
#   }

#   spec {
#     replicas = 2

#     selector {
#       match_labels = {
#         app = "prodxcloud-store"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "prodxcloud-store"
#         }
#       }

#       spec {
#         container {
#           image = "joelwembo/prodxcloud-store:latest"  # Update with your ECR repository and image tag
#           name  = "prodxcloud-store"
#           port {
#             container_port = 80  # Assuming your React app runs on port 3000
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_service" "prodxcloud_store_service" {
#   metadata {
#     name = "prodxcloud-store"
#   }

#   spec {
#     selector = {
#       app = "prodxcloud-store"
#     }

#     port {
#       port        = 80
#       target_port = 80  # Assuming your React app runs on port 3000
#     }

#     type = "LoadBalancer"
#   }
# }


# Output the DNS name of the load balancer
output "load_balancer_dns" {
  value = aws_lb.my_load_balancer.dns_name
}
