# Step 3
## AMI Security group setting using HashiCorp Configuration Language (HCL)
resource "aws_security_group" "prodxcloud-SG" {
  name        = var.instance_secgroupname
  description = var.instance_secgroupname
  # vpc_id      = var.instance_vpc_id # custom ID 
  vpc_id      = aws_vpc.prodxcloud-vpc.id # created via terraform in vpc.tf

  // To Allow SSH Transport
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = lookup(ingress.value, "description", null)
      from_port   = lookup(ingress.value, "from_port", null)
      to_port     = lookup(ingress.value, "to_port", null)
      protocol    = lookup(ingress.value, "protocol", null)
      cidr_blocks = lookup(ingress.value, "cidr_blocks", null)
    }
  }

  # Outboud Rule for SG
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "prodxcloud-SG"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_vpc.prodxcloud-vpc]
}