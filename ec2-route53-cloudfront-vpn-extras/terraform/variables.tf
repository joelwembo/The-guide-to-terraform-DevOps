variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "backend_organization" {
  type    = string
  default = "prodxcloud"
}

variable "backend_worspaces" {
  type    = string
  default = "prodxcloud"
}

variable "domain_name" {
  description = "The domain name for Route 53"
  default     = "prodxcloud.io"
}

variable "custom_domain_1" {
  description = "Lab / Studio custom domain for our ec2 services"
  default = "studio.prodxcloud.io"
}

variable "custom_domain_2" {
  description = "Lab / Studio custom domain for our ec2 services"
  default = "ec2.prodxcloud.io"
}

variable "custom_domain_3" {
  description = "Lab / Studio custom domain for our ec2 services"
  default = "qa.prodxcloud.io"
}

variable "custom_domain_4" {
  description = "Lab / Studio custom domain for our ec2 services"
  default = "dev.prodxcloud.io"
}


# S3 bucket name for site 1
variable "site_bucket_name_1" {
  description = "react website website running under cloudfront"
  default = "dev.prodxcloud.io"
}

# S3 bucket name for site 2
variable "site_bucket_name_2" {
  default = "qa.prodxcloud.io"
}

variable "domain_name_ZoneID" {
  description = "domain custom id by default"
  default = ""
}


variable "access_key" {
  default = ""
}
variable "secret_key" {
  default = ""
}

variable "bucket" {
  default = "prodxcloud-state-bucket"
}


variable "cidr_block" {
  default = "10.0.0.0/16"
}
variable "subnet" {
  default = "10.0.0.0/24"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0e001c9271cf7f3b9"
}

variable "publicip" {
  type = bool
  default = true
  
}
variable "instance_vpc_id" {
  type    = string
  default = "vpc-0ac56bffa3dd131d1"
}

variable "instance_subnet_id" {
  type    = string
  default = "subnet-04b72c3048ab1cb86"
}

variable "instance_keyName" {
  type    = string
  default = "prodxcloud"
}

variable "instance_secgroupname" {
  description = "This is a security Group Name"
  type        = string
  default     = "prodxcloud-SG"
}

variable "instance_publicip" {
  type    = bool
  default = true
}

variable "aws_availability_zone" {
  type    = string
  default = "us-east-1a"
}


variable "ingress_rules" {
  default = {
    "my ingress rule" = {
      "description" = "For HTTP"
      "from_port"   = "80"
      "to_port"     = "80"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    },

    "all ingress rule" = {
      "description" = "All"
      "from_port"   = "0"
      "to_port"     = "9999"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    },
    "my other ingress rule" = {
      "description" = "For SSH"
      "from_port"   = "22"
      "to_port"     = "22"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    },

    "Postgres port" = {
      "description" = "For HTTP postgres"
      "from_port"   = "5432"
      "to_port"     = "5432"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    },

    "Jenkins port" = {
      "description" = "For Jenkins"
      "from_port"   = "8080"
      "to_port"     = "8080"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    },

     "React Application port" = {
      "description" = "For React"
      "from_port"   = "3000"
      "to_port"     = "3000"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    },

    "Django Application port" = {
      "description" = "For Django"
      "from_port"   = "8585"
      "to_port"     = "8585"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    }

    "All Ports" = {
      "description" = "For HTTP all ports"
      "from_port"   = "3000"
      "to_port"     = "65535"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    }
  }
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "Security group rules"
}