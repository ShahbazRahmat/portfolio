provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "eks-blueprint"
      ManagedBy   = "terraform"
      Environment = var.environment
      Repository  = "github.com/shahbazkareem/terraform-aws-eks-blueprint"
    }
  }
}
