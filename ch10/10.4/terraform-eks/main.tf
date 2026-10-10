terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# 리전은 aws configure(또는 AWS_REGION)에 적은 값을 쓴다. 한 곳에서만 정한다.
# AWS 새 가입 방식은 리전이 연락처 국가로 고정된다(한국은 ap-southeast-2). 10.3 참조.
provider "aws" {
  region = var.region
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.cluster_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = var.tags
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.36"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  # 클러스터를 만든 IAM principal에게 Kubernetes admin(access entry)을 부여한다.
  # 모듈 v20 기본값이 false라, 이 옵션이 없으면 생성자조차 kubectl 실행 시
  # "You must be logged in to the server (401)"이 발생한다. (실배포 검증으로 확인)
  enable_cluster_creator_admin_permissions = true

  # IRSA 대신 EKS Pod Identity를 쓴다. IRSA에 필요한 OIDC provider는 AWS 새 가입 방식의
  # SCP(iam:*Provider*)가 플랜과 상관없이 거부한다. Pod Identity는 두 가입 방식 모두에서 동작한다.
  # (2026-10-04 신규 무료 플랜 계정 실검증)
  enable_irsa = false

  cluster_addons = {
    eks-pod-identity-agent = {}
  }

  # 노드끼리는 모든 포트를 연다. 모듈 v20의 노드 보안 그룹은 노드 사이에 1025 이상 포트만 허용한다.
  # backend 컨테이너는 80번을 쓰므로, 이 규칙이 없으면 다른 노드의 frontend가 backend를 부를 때 응답이 없다.
  # (2026-10-10 run-40: ALB 주소의 /api 요청 절반이 504)
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
  }

  eks_managed_node_groups = {
    default = {
      # 무료 플랜은 무료 등급 대상이 아닌 인스턴스(t3.medium 등) 실행을 거부한다.
      # c7i-flex.large는 무료 등급 대상이고 t3.medium과 같은 2 vCPU, 4GB다.
      instance_types = ["c7i-flex.large"]
      min_size       = 2
      max_size       = 4
      desired_size   = 3
    }
  }

  tags = var.tags
}
