
# resource "aws_launch_configuration" "prodxcloud-launch_config" {
#   name          = "prodxcloud-launch_config"
#   image_id      = var.instance_ami
#   instance_type = var.instance_type

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_autoscaling_group" "prodxcloud-autoscaling-group" {
#   launch_configuration = aws_launch_configuration.prodxcloud-launch_config.id
#   min_size             = 1
#   max_size             = 3
#   desired_capacity     = 2
#   vpc_zone_identifier  = [element(aws_subnet.prodxcloud_public_subnets.*.id, 1), 
#                           element(aws_subnet.prodxcloud_public_subnets.*.id, 2)]

#   tag {
#     key                 = "prxcloud"
#     value               = "prodx-instance-1"
#     propagate_at_launch = true
#   }
# }

# resource "aws_autoscaling_policy" "scale_up" {
#   name                   = "scale_up"
#   scaling_adjustment     = -1
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 300
#   autoscaling_group_name = aws_autoscaling_group.prodxcloud-autoscaling-group.name
# }

# resource "aws_autoscaling_policy" "scale_down" {
#   name                   = "scale_down"
#   scaling_adjustment     = -1
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 300
#   autoscaling_group_name = aws_autoscaling_group.prodxcloud-autoscaling-group.name
# }

# resource "aws_cloudwatch_metric_alarm" "cpu_high" {
#   alarm_name          = "cpu_high"
#   comparison_operator = "GreaterThanThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "120"
#   statistic           = "Average"
#   threshold           = "70"

#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.prodxcloud-autoscaling-group.name
#   }

#   alarm_actions = [
#     aws_autoscaling_policy.scale_up.arn
#   ]

#   ok_actions = [
#     aws_autoscaling_policy.scale_down.arn
#   ]
# }

# resource "aws_cloudwatch_metric_alarm" "cpu_low" {
#   alarm_name          = "cpu_low"
#   comparison_operator = "LessThanThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "120"
#   statistic           = "Average"
#   threshold           = "30"

#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.prodxcloud-autoscaling-group.name
#   }

#   alarm_actions = [
#     aws_autoscaling_policy.scale_down.arn
#   ]

#   ok_actions = [
#     aws_autoscaling_policy.scale_up.arn
#   ]
# }
