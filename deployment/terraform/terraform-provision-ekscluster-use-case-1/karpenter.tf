# locals {
#   capacity_type = ["on-demand"]
#   allowed_instance_types = [
#     "m5.xlarge",
#     "m5.2xlarge",
#     "c5.large",
#     "c5.xlarge",
#     "c5.2xlarge",
#     "m5.large",
#   ]
#   allowed_instance_type_java = [
#     "m5.large",
#     "m5.xlarge",
#     "m5.2xlarge",
#     "m5.4xlarge",
#   ]
#   allowed_instance_type_golang = [
#     "c5.large",
#     "c5.xlarge",
#     "c5.2xlarge"
#   ]
# }

# data "aws_eks_cluster" "this" {
#   name = var.cluster-name
# }

# data "aws_region" "current" {}

# resource "kubernetes_namespace" "karpenter" {
#   metadata {
#     annotations = {
#       name = "karpenter"
#     }
#     name = "karpenter"
#   }
# }

# module "iam_assumable_role_karpenter" {
#   source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
#   version                       = "4.7.0"
#   create_role                   = true
#   role_name                     = "karpenter-controller-${var.environment_class}-${data.aws_region.current.name}"
#   provider_url                  = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
#   oidc_fully_qualified_subjects = ["system:serviceaccount:${kubernetes_namespace.karpenter.id}:karpenter"]
# }

# resource "aws_iam_role_policy" "karpenter_contoller" {
#   name = "karpenter-policy"
#   role = module.iam_assumable_role_karpenter.iam_role_name

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "ec2:CreateLaunchTemplate",
#           "ec2:CreateFleet",
#           "ec2:RunInstances",
#           "ec2:CreateTags",
#           "iam:PassRole",
#           "ec2:TerminateInstances",
#           "ec2:DeleteLaunchTemplate",
#           "ec2:DescribeLaunchTemplates",
#           "ec2:DescribeInstances",
#           "ec2:DescribeSecurityGroups",
#           "ec2:DescribeSubnets",
#           "ec2:DescribeInstanceTypes",
#           "ec2:DescribeInstanceTypeOfferings",
#           "ec2:DescribeAvailabilityZones",
#           "ssm:GetParameter"
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#     ]
#   })
# }
  
# data "aws_iam_policy" "ssm_managed_instance" {
#   arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }

# resource "aws_iam_role_policy_attachment" "karpenter_ssm_policy" {
#   role       = module.eks.worker_iam_role_name
#   policy_arn = data.aws_iam_policy.ssm_managed_instance.arn
# }

# resource "aws_iam_instance_profile" "karpenter" {
#   name = "KarpenterNodeInstanceProfile-${var.cluster-name}"
#   role = module.eks.worker_iam_role_name
# }

# resource "helm_release" "karpenter" {
#   namespace = kubernetes_namespace.karpenter.id

#   name       = "karpenter"
#   repository = "https://charts.karpenter.sh"
#   chart      = "karpenter"
#   version    = "0.9.0"

#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = module.iam_assumable_role_karpenter.iam_role_arn
#   }

#   set {
#     name  = "clusterName"
#     value = var.cluster-name
#   }

#   set {
#     name  = "clusterEndpoint"
#     value = data.aws_eks_cluster.this.endpoint
#   }
#   set {
#     name  = "aws.defaultInstanceProfile"
#     value = aws_iam_instance_profile.karpenter.name
#   }
# }

# data "kubectl_path_documents" "provisioner_manifests" {
#   pattern = "./k8s/*.yaml"
#   vars = {
#     cluster_name = var.cluster-name
#   }
# }
  
# resource "kubectl_manifest" "provisioners" {
#   for_each  = data.kubectl_path_documents.provisioner_manifests.manifests
#   yaml_body = each.value
# }