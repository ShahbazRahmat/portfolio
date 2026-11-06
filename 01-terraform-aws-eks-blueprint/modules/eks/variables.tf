variable "name" {
  description = "Cluster name (also used for IAM role names)."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version of the control plane."
  type        = string
  default     = "1.30"
}

variable "private_subnet_ids" {
  description = "Private subnets for nodes and internal load balancers."
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "Public subnets for internet-facing load balancers."
  type        = list(string)
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "CIDRs allowed to reach the public API endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "node_groups" {
  description = "Managed node groups to create."
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    min_size       = number
    max_size       = number
    desired_size   = number
  }))
  default = {}
}
