variable "region" {
  description = "AWS region. 비워 두면 aws configure(또는 AWS_REGION)의 리전을 쓴다"
  type        = string
  default     = null
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "cicd-learning-eks"
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default = {
    Environment = "learning"
    Project     = "cicd-learning-kit"
  }
}
