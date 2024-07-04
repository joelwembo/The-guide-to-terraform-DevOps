# Terraform state management with AWS S3 bucket and DynamoDB LockID before any other resource
resource "aws_s3_bucket" "prodxcloud-state-bucket" {
  bucket = "prodxcloud-state-bucket-2"  # Change the bucket name as needed

  versioning {
    enabled = false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "prodxcloud Terraform state bucket"
    Environment = "PROD"
  }
}

resource "aws_dynamodb_table" "data_prodxcloud_tf_lockid" {
  name         = "data_prodxcloud_tf_lockid_2"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  hash_key = "LockID"

  tags = {
    Name        = "prodxcloud Terraform locks table LocksID"
    Environment = "PROD"
  }

   lifecycle {
    create_before_destroy = true
  }
}



