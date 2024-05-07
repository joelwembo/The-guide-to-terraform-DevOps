# terraform {
#   backend "remote" {  
#     hostname="app.terraform.io"  
#     organization = "prodxcloud" 
#     workspaces {
#       prefix = "prodxcloud" 
#     }
#   }
# }

terraform {
  backend "s3" {
    bucket         = "prodxcloud-store"
    region         = "us-east-1"
    key            = "state/terraform.tfstate"
    # dynamodb_table = "data_onents_tf_lockid"
    encrypt        = true
  }
}


