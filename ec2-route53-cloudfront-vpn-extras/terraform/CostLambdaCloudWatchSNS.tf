
# # Enabling CloudWatch monitoring, creating Lambda functions to start and stop the instance,
# # and setting up cost monitoring with AWS Cost and Usage Reports.

# # IAM Role for Lambda Functions
# resource "aws_iam_role" "lambda_exec_role" {
#   name = "lambda_exec_role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Effect = "Allow",
#         Sid    = "",
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
#   role       = aws_iam_role.lambda_exec_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }

# resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
#   role       = aws_iam_role.lambda_exec_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
# }

# resource "aws_iam_role_policy" "lambda_policy" {
#   name = "lambda_policy"
#   role = aws_iam_role.lambda_exec_role.id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "logs:CreateLogGroup",
#           "logs:CreateLogStream",
#           "logs:PutLogEvents"
#         ],
#         Resource = "*"
#       },
#       {
#         Effect = "Allow",
#         Action = [
#           "ce:GetCostAndUsage",
#           "sns:Publish"
#         ],
#         Resource = "*"
#       }
#     ]
#   })
# }


# # Create Zip folder
# data "archive_file" "lambda_function_file" {
#   type = "zip"
#   source_dir = "${path.module}/lambda_functions"
#   output_path = "lambda_functions.zip"
# }

# # Lambda Function to Start EC2 Instance
# resource "aws_lambda_function" "start_instance" {
#   filename         = "lambda_functions.zip"
#   function_name    = "start_instance"
#   role             = aws_iam_role.lambda_exec_role.arn
#   handler          = "lambda_functions/start_instance.lambda_handler"
#   # source_code_hash = filebase64sha256("lambda_functions.zip")
#   source_code_hash = data.archive_file.lambda_function_file.output_base64sha256
#   runtime          = "python3.9"

#   depends_on = [ aws_instance.prodxcloud-lab-1]
# }

# # Lambda Function to Stop EC2 Instance
# resource "aws_lambda_function" "stop_instance" {
#   filename         = "lambda_functions.zip"
#   function_name    = "stop_instance"
#   role             = aws_iam_role.lambda_exec_role.arn
#   handler          = "lambda_functions/stop_instance.lambda_handler"
#   # source_code_hash = filebase64sha256("lambda_functions.zip")
#   source_code_hash = data.archive_file.lambda_function_file.output_base64sha256
#   runtime          = "python3.9"

#   depends_on = [ aws_instance.prodxcloud-lab-1]
# }

# # Lambda Function for Cost Monitoring
# resource "aws_lambda_function" "cost_monitoring" {
#   filename         = "lambda_functions.zip"
#   function_name    = "cost_monitoring"
#   role             = aws_iam_role.lambda_exec_role.arn
#   handler          = "lambda_functions/cost_monitoring.lambda_handler"
#   # source_code_hash = filebase64sha256("lambda_functions.zip")
#   source_code_hash = data.archive_file.lambda_function_file.output_base64sha256
#   runtime          = "python3.9"
#   environment {
#     variables = {
#       SNS_TOPIC_ARN = aws_sns_topic.cost_alerts.arn
#     }
#   }

#   depends_on = [ aws_instance.prodxcloud-lab-1]
# }

# # CloudWatch Rule to Start EC2 Instance
# resource "aws_cloudwatch_event_rule" "start_instance_rule" {
#   name                = "start_instance_rule"
#   description         = "Triggers Lambda to start EC2 instance"
#   schedule_expression = "cron(0 8 * * ? *)" # Adjust to your preferred schedule (e.g., 8 AM UTC)
# }

# resource "aws_cloudwatch_event_target" "start_instance_target" {
#   rule      = aws_cloudwatch_event_rule.start_instance_rule.name
#   target_id = "start_instance"
#   arn       = aws_lambda_function.start_instance.arn
# }

# resource "aws_lambda_permission" "allow_start_instance" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.start_instance.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.start_instance_rule.arn
# }

# # CloudWatch Rule to Stop EC2 Instance
# resource "aws_cloudwatch_event_rule" "stop_instance_rule" {
#   name                = "stop_instance_rule"
#   description         = "Triggers Lambda to stop EC2 instance"
#   schedule_expression = "cron(0 20 * * ? *)" # Adjust to your preferred schedule (e.g., 8 PM UTC)
# }

# resource "aws_cloudwatch_event_target" "stop_instance_target" {
#   rule      = aws_cloudwatch_event_rule.stop_instance_rule.name
#   target_id = "stop_instance"
#   arn       = aws_lambda_function.stop_instance.arn
# }

# resource "aws_lambda_permission" "allow_stop_instance" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.stop_instance.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.stop_instance_rule.arn
# }

# # CloudWatch Rule for Cost Monitoring
# resource "aws_cloudwatch_event_rule" "cost_monitoring_schedule" {
#   name                = "cost_monitoring_schedule"
#   description         = "Triggers Lambda to check AWS costs"
#   schedule_expression = "rate(1 day)" # Adjust the frequency as needed
# }

# resource "aws_cloudwatch_event_target" "cost_monitoring_target" {
#   rule      = aws_cloudwatch_event_rule.cost_monitoring_schedule.name
#   target_id = "cost_monitoring"
#   arn       = aws_lambda_function.cost_monitoring.arn
# }

# resource "aws_lambda_permission" "allow_cost_monitoring" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.cost_monitoring.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.cost_monitoring_schedule.arn
# }

# # SNS Topic for CloudWatch Alarms and Cost Alerts
# resource "aws_sns_topic" "alerts" {
#   name = "cloudwatch-alerts"
# }

# resource "aws_sns_topic" "cost_alerts" {
#   name = "cost-alerts"
# }

# # Subscribe an email to the SNS Topics
# resource "aws_sns_topic_subscription" "email_subscription_alerts" {
#   topic_arn = aws_sns_topic.alerts.arn
#   protocol  = "email"
#   endpoint  = "joel.wembo@protonmail.com" # Replace with your email
# }

# resource "aws_sns_topic_subscription" "email_subscription_cost_alerts" {
#   topic_arn = aws_sns_topic.cost_alerts.arn
#   protocol  = "email"
#   endpoint  = "joel.wembo@protonmail.com" # Replace with your email
# }

# # CloudWatch Alarm for CPU Utilization
# resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
#   alarm_name          = "cpu-utilization-alarm"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "120"
#   statistic           = "Average"
#   threshold           = "80"
#   alarm_description   = "This alarm triggers when CPU utilization exceeds 80%"
#   actions_enabled     = true

#   alarm_actions = [aws_sns_topic.alerts.arn]
#   ok_actions    = [aws_sns_topic.alerts.arn]

#   dimensions = {
#     InstanceId = aws_instance.prodxcloud-lab-1.id
#   }

#   depends_on = [ aws_instance.prodxcloud-lab-1]
# }

# # S3 Bucket for Cost and Usage Reports
# resource "aws_s3_bucket" "cost_usage_reports" {
#   bucket = "my-cost-usage-reports-bucket" # Replace with your unique bucket name
# #   acl    = "private"
# }

# resource "aws_s3_bucket_policy" "cost_usage_reports_policy" {
#   bucket = aws_s3_bucket.cost_usage_reports.id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = [
#           "s3:GetBucketAcl",
#           "s3:GetBucketPolicy"
#         ],
#         Effect   = "Allow",
#         Resource = "arn:aws:s3:::${aws_s3_bucket.cost_usage_reports.id}",
#         Principal = {
#           Service = "billingreports.amazonaws.com"
#         }
#       },
#       {
#         Action = [
#           "s3:PutObject"
#         ],
#         Effect   = "Allow",
#         Resource = "arn:aws:s3:::${aws_s3_bucket.cost_usage_reports.id}/*",
#         Principal = {
#           Service = "billingreports.amazonaws.com"
#         }
#       }]
#     } )

#    //end 
# }
    



   
  
   
