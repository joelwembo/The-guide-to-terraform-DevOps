# Creating S3 bucket and apply force destroy So, when going to destroy it won't throw error 'Bucket is not empty'
resource "aws_s3_bucket" "site_bucket_name_1" {
  bucket        = var.site_bucket_name_1
  acl           = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }
}

# Using null resource to push all the files in one time instead of sending one by one
resource "null_resource" "upload-to-S3-1" {
  provisioner "local-exec" {
    command = "aws s3 sync ${path.module}/website-contents s3://${aws_s3_bucket.site_bucket_name_1.id}"
  }
}



# Keeping S3 bucket private
resource "aws_s3_bucket_public_access_block" "webiste_bucket_access" {
  bucket                  = aws_s3_bucket.site_bucket_name_1.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# This Terraform code defines an IAM policy document that allows CloudFront to access objects in the S3 bucket
data "aws_iam_policy_document" "website_bucket" {
  statement {
    actions   = ["s3:GetObject"]
    effect = "Allow"
    resources = ["${aws_s3_bucket.site_bucket_name_1.arn}/*"]
    
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}


resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.site_bucket_name_1.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


## CloudFront

# CloudFront distribution with S3 origin, HTTPS redirect, IPv6 enabled, no cache, and ACM SSL certificate.
resource "aws_cloudfront_distribution" "cdn_static_website" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  origin {
    domain_name              = "${aws_s3_bucket.site_bucket_name_1.bucket}.s3.amazonaws.com"
    origin_id                = "my-s3-origin"
    # origin_access_control_id = aws_cloudfront_origin_access_control.default.id
  }


  aliases = ["dev.socialcloudsync.com"]

  default_cache_behavior {
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "my-s3-origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.acm_ssl.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  depends_on = [ aws_s3_bucket.site_bucket_name_1, aws_acm_certificate.acm_ssl]


}

# CloudFront origin access control for S3 origin type with always signing using sigv4 protocol
resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "cloudfront OAC"
  description                       = "description OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Origin Access Identity for S3 website"
}


# # Creating the S3 policy and applying it for the S3 bucket

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.site_bucket_name_1.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.site_bucket_name_1.arn}/*"
      }
    ]
  })

  depends_on = [ aws_cloudfront_distribution.cdn_static_website ]
}



output "S3WebHostingSite1" {
  value = "${aws_s3_bucket.site_bucket_name_1.bucket}.s3.amazonaws.com"
}

# Output the CloudFront distribution URL using the domain name of the cdn_static_website resource.
output "cloudfront_url" {
  value = aws_cloudfront_distribution.cdn_static_website.domain_name
}

output "cloudfront_zone" {
  value = aws_cloudfront_distribution.cdn_static_website.hosted_zone_id
}