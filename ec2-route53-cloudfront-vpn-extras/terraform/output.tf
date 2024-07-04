# output "state_s3_bucket_name" {
#   value = aws_s3_bucket.prodxcloud-state-bucket.id
# }

# output "state_dynamodb_table_name" {
#   value = aws_dynamodb_table.data_prodxcloud_tf_lockid.id
# }

# output "ACMSSLARN" {
#   value = aws_acm_certificate.acm_ssl
#   sensitive = true
# }

# output "cidr_block" {
#   value = aws_vpc.prodxcloud-vpc.cidr_block
# }
# output "Vpc-ID" {
#   value = aws_vpc.prodxcloud-vpc
# }

# output "Security-Group" {
#   value = aws_security_group.prodxcloud-SG.id
# }

# output "prodxcloud_public_subnet1" {
#   value = element(aws_subnet.prodxcloud_public_subnets.*.id, 1)
# }

# output "prodxcloud_public_subnet2" {
#   value = element(aws_subnet.prodxcloud_public_subnets.*.id, 2)
# }

# output "prodxcloud_public_subnet3" {
#   value = element(aws_subnet.prodxcloud_public_subnets.*.id, 3)
# }

# # output "private_subnet2" {
# #   value = element(aws_subnet.prodxcloud_private_subnets.*.id, 2)
# # }



# output "EC2-Instance1" {
#   value = aws_instance.prodxcloud-lab-1.id
# }

# output "Instance1publicDNS" {
#   value = aws_instance.prodxcloud-lab-1.public_dns
# }

# output "ec2instance1-IP" {
#   value = aws_instance.prodxcloud-lab-1.public_ip
# }

# output "UBUNTU-AMI-Details" {
#   value =[ data.aws_ami.ubuntu.name, data.aws_ami.ubuntu.id ]
# }

# output "AMAZON-AMI-Details" {
#   value =[ data.aws_ami.amazon-linux-2.name, data.aws_ami.amazon-linux-2.id ]
# }




# output "EC2-Instance2" {
#   value = aws_instance.prodxcloud-lab-2.id
# }

# output "Instance2publicDNS" {
#   value = aws_instance.prodxcloud-lab-2.public_dns
# }

# output "ec2instance2-IP" {
#   value = aws_instance.prodxcloud-lab-2.public_ip
# }


# # # output "SpotInstanceTerraform-IP" {
# # #   value = aws_instance.spot_instance.public_ip
  
# # # }


# # # output "Target-Group" {
# # #   value = aws_lb_target_group.PRODXCLOUD-TG.arn
# # # }

# # # output "Load-Balancer" {
# # #   value = aws_lb.PRODXCLOUD-Load-Balancer.id
# # # }



# # # output for Cost Monitoring with CloudWatch , SNS and Lambda Role
# # output "lambda_start_instance_arn" {
# #   description = "ARN of the Lambda function to start the EC2 instance"
# #   value       = aws_lambda_function.start_instance.arn
# # }

# # output "lambda_stop_instance_arn" {
# #   description = "ARN of the Lambda function to stop the EC2 instance"
# #   value       = aws_lambda_function.stop_instance.arn
# # }

# # output "lambda_cost_monitoring_arn" {
# #   description = "ARN of the Lambda function for cost monitoring"
# #   value       = aws_lambda_function.cost_monitoring.arn
# # }

# # output "cloudwatch_event_rule_start_instance" {
# #   description = "Name of the CloudWatch event rule to start the EC2 instance"
# #   value       = aws_cloudwatch_event_rule.start_instance_rule.name
# # }

# # output "cloudwatch_event_rule_stop_instance" {
# #   description = "Name of the CloudWatch event rule to stop the EC2 instance"
# #   value       = aws_cloudwatch_event_rule.stop_instance_rule.name
# # }

# # output "cloudwatch_event_rule_cost_monitoring" {
# #   description = "Name of the CloudWatch event rule for cost monitoring"
# #   value       = aws_cloudwatch_event_rule.cost_monitoring_schedule.name
# # }

# # output "sns_topic_alerts_arn" {
# #   description = "ARN of the SNS topic for CloudWatch alerts"
# #   value       = aws_sns_topic.alerts.arn
# # }

# # output "sns_topic_cost_alerts_arn" {
# #   description = "ARN of the SNS topic for cost alerts"
# #   value       = aws_sns_topic.cost_alerts.arn
# # }

# # output "cloudwatch_alarm_cpu_utilization" {
# #   description = "Name of the CloudWatch alarm for CPU utilization"
# #   value       = aws_cloudwatch_metric_alarm.cpu_alarm.alarm_name
# # }

# # output "s3_bucket_cost_usage_reports" {
# #   description = "Name of the S3 bucket for Cost and Usage Reports"
# #   value       = aws_s3_bucket.cost_usage_reports.bucket
# # }

# output "CloudFrontDetails" {
#     value = [aws_cloudfront_distribution.cloudfront_ec2_instance_1]
  
# }

# #   output "WAFID" {
# #     value = aws_wafv2_web_acl.prodxcloud-waf.id  
# #   }

