variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
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
