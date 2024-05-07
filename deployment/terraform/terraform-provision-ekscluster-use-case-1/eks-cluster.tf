resource "aws_iam_role" "prodxcloud-cluster" {
  name = "prodxcloud-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "prodxcloud-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.prodxcloud-cluster.name
}

resource "aws_eks_cluster" "prodxcloud-cluster" {
  
  name     = "prodxcloud-cluster"
  role_arn = aws_iam_role.prodxcloud-cluster.arn
  version  = "1.29"

  # # multi cluster
  # count = 3
  # name            = "${var.cluster-name}_${count.index}"
  # role_arn        = "${aws_iam_role.prodxcloud-cluster.arn}"

  # assign ips subnet
  vpc_config {
    subnet_ids = [
      aws_subnet.private-us-east-1a.id,
      aws_subnet.private-us-east-1b.id,
      aws_subnet.public-us-east-1a.id,
      aws_subnet.public-us-east-1b.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.prodxcloud-cluster-AmazonEKSClusterPolicy]
}
