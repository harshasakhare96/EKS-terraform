module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.17"
  subnets         = module.vpc.private_subnets
  manage_aws_auth = false
  map_roles = [
    {
      rolearn  = "arn:aws:iam::412866647334:role/test-eks-JU7rGoiC2020122215301741080000000c"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers","system:nodes"]
    },
  ]
  tags = {
    Environment = "test"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = module.vpc.vpc_id
#  worker_groups = [
#    {
#      name                          = "worker-group-1"
#      instance_type                 = "t2.small"
#      additional_userdata           = "echo test"
#      asg_max_size                  = 3
#      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
#    }
#  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

/*
module "eks_node_group" {
  source = "cloudposse/eks-node-group/aws"
  name      = "test-ng"
  subnet_ids         = module.vpc.private_subnets
  cluster_name       = local.cluster_name
  instance_types     = ["t3.small"]
  desired_size       = 1
  min_size           = 1
  max_size           = 1
  kubernetes_version = "1.17"
  kubernetes_labels  = {disk = "ssd"}
  disk_size          = 20

}
resource "aws_eks_node_group" "managed_workers_a" {
  cluster_name    = local.cluster_name
  node_group_name = "eks-test-managed-workers"
  node_role_arn   = "arn:aws:iam::412866647334:role/test-eks-JU7rGoiC2020122215301741080000000c"
  subnet_ids      = module.vpc.private_subnets
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  instance_types = split(",", "t3.small")
  labels = {
    lifecycle = "OnDemand"
    app = "nginx"
  }
  remote_access {
    ec2_ssh_key               = "gw-test-keypair"
    source_security_group_ids = ["sg-08190203cc01889dc"]
  }
  lifecycle {
    create_before_destroy = true
  }
}
*/
