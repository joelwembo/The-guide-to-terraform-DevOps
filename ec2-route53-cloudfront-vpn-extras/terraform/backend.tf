terraform {
  backend "s3" {
    bucket         = "prodxcloud-state-bucket-2"
    region         = "us-east-1"
    key            = "infra/Ec2-Instance-TFCloud-2/terraform.tfstate"
    dynamodb_table = "data_prodxcloud_tf_lockid_2"
    encrypt = false
  }
}

