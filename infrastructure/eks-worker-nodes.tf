#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#

module "self_managed_node_group" {
  source = "terraform-aws-modules/eks/aws//modules/self-managed-node-group"

  name                = "self-managed-nodes"
  cluster_name        = "my-demo-cluster"
  cluster_version     = "1.22"
  cluster_endpoint    = aws_eks_cluster.my-demo-cluster.endpoint
  
  vpc_id     = aws_vpc.proper_vpc_name_goes_here.id
  subnet_ids = aws_subnet.proper_subnet_name_goes_here[*].id
  vpc_security_group_ids = [
    aws_security_group.my-demo-cluster-sg.id
  ]

  min_size     = 3 # minimum 3 nodes are required
  max_size     = 5 # just a random number since there is no constraint specified
  desired_size = 3

  launch_template_name   = "separate-self-mng"
  instance_type          = "m5.large"

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}






# resource "aws_iam_role" "demo-node" {
#   name = "terraform-eks-demo-node"

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "ec2.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# POLICY
# }

# resource "aws_iam_role_policy_attachment" "demo-node-AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.demo-node.name
# }

# resource "aws_iam_role_policy_attachment" "demo-node-AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.demo-node.name
# }

# resource "aws_iam_role_policy_attachment" "demo-node-AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.demo-node.name
# }

# resource "aws_eks_node_group" "demo" {
#   cluster_name    = aws_eks_cluster.demo.name
#   node_group_name = "demo"
#   node_role_arn   = aws_iam_role.demo-node.arn
#   subnet_ids      = aws_subnet.demo[*].id

#   scaling_config {
#     desired_size = 1
#     max_size     = 1
#     min_size     = 1
#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.demo-node-AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.demo-node-AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.demo-node-AmazonEC2ContainerRegistryReadOnly,
#   ]
# }
