data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role_cluster" {
  name               = "anuvind_eks-trial-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.role_cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceControllerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.role_cluster.name
}


resource "aws_eks_cluster" "first" {
  name     = var.cluster_name
  role_arn = aws_iam_role.role_cluster.arn

  vpc_config {
    subnet_ids = [var.subnet_1, var.subnet_2]
  }
}

