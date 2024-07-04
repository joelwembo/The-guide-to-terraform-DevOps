
## New solution

# # Step 1
# Create Zone id which also depend on step 2 : VPC ID
# AWS Route53 zone data source with the domain name and private zone set to false
# data "aws_route53_zone" "zone" {
#   provider     = aws.use_default_region
#   name         = var.domain_name
#   private_zone = false

# }

# # Create Zone id
resource "aws_route53_zone" "prodxcloud_io_zone_1" {
  name = var.domain_name
  # vpc {
  #   vpc_id = aws_vpc.prodxcloud-vpc.id
  # }

  # depends_on = [ aws_vpc.prodxcloud-vpc]
}

output "prodxcloud_io_ZoneID" {
  value = aws_route53_zone.prodxcloud_io_zone_1
  
}

# # Step 2 
# # Request SSL Certificate for your domain name
# # Define the ACM certificate
resource "aws_acm_certificate" "acm_ssl" {
  provider                  = aws.use_default_region
  domain_name               = var.domain_name
  subject_alternative_names = ["*.prodxcloud.io", "www.prodxcloud.io"]
  validation_method         = "EMAIL"


  lifecycle {
    create_before_destroy = true
  }
}

# # Define the DNS validation record

# Define the DNS validation records for ACM
# resource "aws_route53_record" "acm_ssl_cert_validation_record" {
#   provider = aws.use_default_region
#   for_each = {
#     for dvo in aws_acm_certificate.acm_ssl.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   zone_id = aws_route53_zone.prodxcloud_io_zone_1.id
#   name    = each.value.name
#   type    = each.value.type
#   records = [each.value.record]
#   ttl     = 60

#   # depends_on = [ aws_route53_zone.prodxcloud_io_zone_1 ]
# }

# ACM Certificate Validation
# resource "aws_acm_certificate_validation" "certificate_validation_1" {
#   provider                = aws.use_default_region
#   certificate_arn         = aws_acm_certificate.acm_ssl.arn
#   validation_record_fqdns = [for record in aws_route53_record.acm_ssl_cert_validation_record : record.fqdn]
# }

# Step 5
# # CloudFront Distribution with IP address as origin and custom domain name as alternative domain
# # Define CloudFront distribution
resource "aws_cloudfront_distribution" "cloudfront_ec2_instance_1" {
  origin {
    domain_name = aws_instance.prodxcloud-lab-1.public_dns
    origin_id   =  aws_instance.prodxcloud-lab-1.public_ip

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["prodxcloud.io", "www.prodxcloud.io", "*.prodxcloud.io"]


  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = aws_instance.prodxcloud-lab-1.public_ip

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  # WAF Configuration (AWS WAFv2)
  # web_acl_id = aws_wafv2_web_acl.prodxcloud-waf.id


  # SSL Certificate for CloudFront
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.acm_ssl.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "prodxcloud.io-distribution"
  }

  depends_on = [ aws_instance.prodxcloud-lab-1 ]
}



# Step 6
# Define Route53 record for the domain representing cloudfront app
resource "aws_route53_record" "example" {
  zone_id =aws_route53_zone.prodxcloud_io_zone_1.id
  name    = "prodxcloud.io"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cloudfront_ec2_instance_1.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront_ec2_instance_1.hosted_zone_id
    evaluate_target_health = false
  }
}

# Define Route53 record for www
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.prodxcloud_io_zone_1.id
  name    = "www.prodxcloud.io"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cloudfront_ec2_instance_1.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront_ec2_instance_1.hosted_zone_id
    evaluate_target_health = false
  }
}


# Define Route53 wildcard record
resource "aws_route53_record" "wildcard" {
  zone_id = aws_route53_zone.prodxcloud_io_zone_1.id
  name    = "*.prodxcloud.io"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cloudfront_ec2_instance_1.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront_ec2_instance_1.hosted_zone_id
    evaluate_target_health = false
  }
}

# Route53 record for ec2.prodxcloud.io to the public IP of the EC2 instance A
resource "aws_route53_record" "ec2-record" {
  zone_id =   aws_route53_zone.prodxcloud_io_zone_1.id
  name    =  var.custom_domain_1
  type    = "A"
  ttl     = 60

  records = [aws_instance.prodxcloud-lab-1.public_ip]
  depends_on = [ aws_instance.prodxcloud-lab-1]
}

# Route53 record for studio.prodxcloud.io to the public IP of the EC2 instance B
# resource "aws_route53_record" "ec2-studio-record" {
#   zone_id =   aws_route53_zone.prodxcloud_io_zone_1.id
#   name    = var.custom_domain_2
#   type    = "A"
#   ttl     = 60

#   records = [aws_instance.prodxcloud-lab-2.public_ip]
#   depends_on = [ aws_instance.prodxcloud-lab-2]
# }


# Route53 record for our static front-end app after completing with bucket and cloudfront
resource "aws_route53_record" "wildcard-dev" {
  zone_id = aws_route53_zone.prodxcloud_io_zone_1.id
  name    = "dev.prodxcloud.io"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn_static_website.domain_name
    zone_id                = aws_cloudfront_distribution.cdn_static_website.hosted_zone_id
    evaluate_target_health = false
  }
}








