
resource "aws_s3_bucket" "prodxcloud-st-azure" {
  bucket = "prodxcloud-st-azure"  # Change the bucket name as needed

  versioning {
    enabled = true
  }

#   lifecycle {
#     prevent_destroy = true
#   }

  tags = {
    Name        = "Terraform Azure state bucket"
    Environment = "Dev"
  }
}

resource "aws_dynamodb_table" "azure_prodxcloud_tf_lockid" {
  name         = "azure_prodxcloud_tf_lockid"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  hash_key = "LockID"

  tags = {
    Name        = "Terraform Azure locks table"
    Environment = "Dev"
  }
  depends_on = [ aws_s3_bucket.prodxcloud-st-azure ]
}

output "s3_bucket_name" {
  value = aws_s3_bucket.prodxcloud-st-azure.id
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.azure_prodxcloud_tf_lockid.id
}

