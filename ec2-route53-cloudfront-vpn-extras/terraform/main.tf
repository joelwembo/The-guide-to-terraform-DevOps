# Step 4 
# Terraform provision AWS EC2 instance with S3 State Management
# Fetch the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  # owners      = ["059978233428"]  # Canonical's AWS account ID
  owners      = ["amazon"]


  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Fetch Amazon Lunix 2 AMI
data "aws_ami" "amazon-linux-2" {
 most_recent = true


 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }


 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}
# AWS EC2 Instance A ( Ubuntu 20.04 lTS )
resource "aws_instance" "prodxcloud-lab-1" {
  # ami                         = var.instance_ami # ami id from variable.tf
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  # subnet_id                 = var.instance_subnet_id  # Custom using subnet id using variable.tf
  subnet_id                   =  element(aws_subnet.prodxcloud_public_subnets.*.id, 1) # dynamic via terraform vpc.tf
  associate_public_ip_address = var.publicip
  key_name                    = var.instance_keyName
  monitoring                  = true # Enable detailed monitoring

  # Remote Provisioner execution using bash scipt file
  # Establishes connection to be used by all

  #  provisioner "file" {
  #   source      = "scripts/user_data.sh"
  #   destination = "/tmp/user_data.sh"

  #    # SSH Connection via terraform
  #    connection {
  #     type        = "ssh"
  #     user        = "ubuntu"
  #     host        = self.public_ip
  #     private_key = file("${path.module}/prodxcloud.pem")
  #   }

  # }

  # Remote Provisioner for User-Data inline commands
  # provisioner "remote-exec" {
  #   # inline = [
  #   #   "sudo apt-get update",
  #   #   "sudo apt-get install -y nginx",
  #   #   "sudo systemctl start nginx",
  #   #   "sudo systemctl enable nginx",
  #   #   "sudo chmod -R 777 /var/www/html",
  #   #   "sudo  echo “User Data Installed by Terraform $(hostname -f)” >> /var/www/html/index.html"
  #   # ]
  #   # generic remote provisioners (i.e. file/remote-exec) with file
  #   inline = [
  #     "chmod +x /tmp/user_data.sh",
  #     "/tmp/user_data.sh",
  #   ]
  #    # SSH connection via terraform
  #    connection {
  #     type        = "ssh"
  #     user        = "ubuntu"
  #     host        = self.public_ip
  #     private_key = file("${path.module}/prodxcloud.pem")

  #   }
  # }
  # remote exec end here
  
  # Attaching security group
  vpc_security_group_ids = [
    aws_security_group.prodxcloud-SG.id
  ]
  root_block_device {
    delete_on_termination = false
    volume_size           = 50
    volume_type           = "gp2"
  }
  tags = {
    Name        = "prodxcloud-lab-1"
    Environment = "DEV"
    OS          = "UBUNTU"
    Managed     = "PRODXCLOUD"
  }

  depends_on = [aws_security_group.prodxcloud-SG, aws_vpc.prodxcloud-vpc, aws_subnet.prodxcloud_public_subnets]

  //end
}


# # AWS EC2 Instance B ( Amazon Lunix 2 )
# resource "aws_instance" "prodxcloud-lab-2" {
#   # ami                         = var.instance_ami # ami id from variable.tf
#   ami                         = data.aws_ami.amazon-linux-2.id
#   instance_type               = var.instance_type
#   # subnet_id                 = var.instance_subnet_id  # Custom using subnet id using variable.tf
#   subnet_id                   =  element(aws_subnet.prodxcloud_public_subnets.*.id, 2) # dynamic via terraform vpc.tf
#   associate_public_ip_address = var.publicip
#   key_name                    = var.instance_keyName
#   # monitoring                  = true # Enable detailed monitoring

#   # Remote Provisioner execution using bash scipt file
#   # Establishes connection to be used by all

# #    provisioner "file" {
# #     source      = "scripts/nodejs-installer-amazon-lunix.sh"
# #     destination = "/tmp/nodejs-installer-amazon-lunix.sh"

# #      # SSH Connection via terraform
# #      connection {
# #       type        = "ssh"
# #       user        = "ec2-ubuntu"
# #       host        = self.public_ip
# #       private_key = file("${path.module}/prodxcloud-ec2-keypair-1.pem")
# #     }

# #   }

#   # Remote Provisioner for User-Data inline commands
# #   provisioner "remote-exec" {
# #     # generic remote provisioners (i.e. file/remote-exec) with file
# #     inline = [
# #       "chmod +x /tmp/nodejs-installer-amazon-lunix.sh",
# #       "/tmp/nodejs-installer-amazon-lunix.sh",
# #     ]
# #      # SSH connection via terraform
# #      connection {
# #       type        = "ssh"
# #       user        = "ec2-user"
# #       host        = self.public_ip
# #       private_key = file("${path.module}/prodxcloud-ec2-keypair-1.pem")

# #     }
# #   }
#   # remote exec end here
  
#   # Attaching security group
#   vpc_security_group_ids = [
#     aws_security_group.prodxcloud-SG.id
#   ]
#   root_block_device {
#     delete_on_termination = false
#     volume_size           = 30
#     volume_type           = "gp2"
#   }
#   tags = {
#     Name        = "prodxcloud-lab-2"
#     Environment = "PROD"
#     OS          = "AMAZON"
#     Managed     = "PRODXCLOUD"
#   }

#   lifecycle {
#     create_before_destroy = "true"
#     ignore_changes = [
#       ami,
#       instance_type,
#     ]
#   }

#   depends_on = [aws_security_group.prodxcloud-SG, aws_subnet.prodxcloud_public_subnets]

# }