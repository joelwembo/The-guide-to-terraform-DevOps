data "tls_certificate" "eks" {
  url = aws_eks_cluster.prodxcloud-cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.prodxcloud-cluster.identity[0].oidc[0].issuer
}



data "aws_iam_policy_document" "validate_oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:aws-validate"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "validate_oidc" {
  assume_role_policy = data.aws_iam_policy_document.validate_oidc_assume_role_policy.json
  name               = "test-oidc"
}

resource "aws_iam_policy" "validate-policy" {
  name = "validate-policy"

  policy = jsonencode({
    Statement = [{
      Action = [
        "s3:ListAllMyBuckets",
        "s3:GetBucketLocation"
      ]
      Effect   = "Allow"
      Resource = "arn:aws:s3:::*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "validate_attach" {
  role       = aws_iam_role.validate_oidc.name
  policy_arn = aws_iam_policy.validate-policy.arn
}

output "test_policy_arn" {
  value = aws_iam_role.validate_oidc.arn
}
