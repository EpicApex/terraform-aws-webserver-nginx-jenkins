module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  version = "15.1.0"
  cluster_version = "1.21"
  cluster_name = local.cluster_name
  subnets      = module.vpc.private_subnets
  worker_ami_name_filter_windows = "*"
  vpc_id = module.vpc.vpc_id

  tags = {
    Environment = "Development"
    Region = "EU"
    Owner = "DevOps"
  }

  node_groups = [
    {
    #     name = "exercise-infra-eks-on-demand"
    #     capacity_type = "ON_DEMAND"
    #     desired_capacity = 1
    #     max_capacity     = 3
    #     min_capacity     = 1
    #     instance_types = ["t3.xlarge"]
    #     disk_size = 150
    #     ami_type = "AL2_x86_64"
    # },
    # {
        name = "exercise-infra-eks-spot"
        capacity_type = "SPOT"
        desired_capacity = 1
        max_capacity     = 3
        min_capacity     = 1
        instance_types = ["t3.xlarge"]
        disk_size = 500
        ami_type = "AL2_x86_64"
        instances_distribution = {
          spot_allocation_strategy = "capacity-optimized"
        }
    }
  ]
  # Ability to add users using ARN roles to aws-auth configmap
  manage_aws_auth = false
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}