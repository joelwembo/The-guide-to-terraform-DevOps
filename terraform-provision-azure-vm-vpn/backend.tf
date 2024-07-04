# terraform {
#   backend "s3" {
#     bucket         = "prodxcloud-st-azure"
#     region         = "us-east-1"
#     key            = "infra/AzureServices/terraform.tfstate"
#     dynamodb_table = "azure_prodxcloud_tf_lockid"
#     encrypt = false
#   }
# }

