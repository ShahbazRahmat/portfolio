variable "name" {
  description = "Resource name prefix."
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name, used in subnet discovery tags."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "Number of Availability Zones."
  type        = number
  default     = 3
}

variable "single_nat" {
  description = "Use one shared NAT Gateway instead of one per AZ (cost control for non-prod)."
  type        = bool
  default     = true
}
