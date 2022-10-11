#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster
#

resource "aws_iam_role" "my-demo-cluster" {
  name = "my-demo-cluster"

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

resource "aws_iam_role_policy_attachment" "my-demo-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.my-demo-cluster.name
}

resource "aws_iam_role_policy_attachment" "my-demo-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.my-demo-cluster.name
}

resource "aws_security_group" "my-demo-cluster-sg" {
  name        = "my-demo-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.proper_vpc_name_goes_here.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-demo-cluster"
  }
}

resource "aws_security_group_rule" "my-demo-cluster-ingress-workstation-https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.my-demo-cluster-sg.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "my-demo-cluster" {
  name     = var.cluster-name
  role_arn = aws_iam_role.my-demo-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.my-demo-cluster-sg.id]
    subnet_ids         = aws_subnet.proper_subnet_name_goes_here[*].id
  }

  enabled_cluster_log_types = ["api", "audit"]

  depends_on = [
    aws_iam_role_policy_attachment.my-demo-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.my-demo-cluster-AmazonEKSServicePolicy,
  ]
}

resource "aws_cloudwatch_log_group" "my-demo-cluster-log" {
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name              = "/aws/eks/${var.cluster-name}/cluster"
  retention_in_days = 7

}