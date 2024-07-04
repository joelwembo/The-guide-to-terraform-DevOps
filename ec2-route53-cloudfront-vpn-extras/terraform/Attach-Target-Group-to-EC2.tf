
# # Attaching Target Groups to EC2
# resource "aws_lb_target_group_attachment" "PRODXCLOUD-TG-Attachment" {
#   target_group_arn = aws_lb_target_group.PRODXCLOUD-TG.arn
#   target_id        = aws_instance.prodxcloud-lab-1.id
#   port             = 80
# }


# # Attaching Target Groups to EC2-Two
# resource "aws_lb_target_group_attachment" "PRODXCLOUD-TG-Attachment2" {
#   target_group_arn = aws_lb_target_group.PRODXCLOUD-TG.arn
#   target_id        = aws_instance.prodxcloud-lab-2.id
#   port             = 80
# }

