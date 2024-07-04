# Improved version Define WAF Web ACL
# resource "aws_wafv2_web_acl" "prodxcloud-waf" {
#   name        = "prodxcloud-waf"
#   description = "prodxcloud WAF"
#   scope       = "CLOUDFRONT"

#   default_action {
#     allow {}
#   }

#   visibility_config {
#     cloudwatch_metrics_enabled = true
#     metric_name                = "example"
#     sampled_requests_enabled   = true
#   }

#   rule {
#     name     = "AWS-AWSManagedRulesCommonRuleSet"
#     priority = 1

#     override_action {
#       none {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesCommonRuleSet"
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWSManagedRulesCommonRuleSet"
#       sampled_requests_enabled   = true
#     }
#   }
# #   depends_on = [ aws_cloudfront_distribution.example ]
# }
  

