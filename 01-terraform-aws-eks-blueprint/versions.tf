terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  # Remote state is strongly recommended for real environments.
  # Uncomment and fill in once you have created the S3 bucket + DynamoDB table:
  #
  # backend "s3" {
  #   bucket         = "<your-terraform-state-bucket>"
  #   key            = "eks-blueprint/terraform.tfstate"
  #   region         = "eu-central-1"
  #   dynamodb_table = "terraform-locks"
  #   encrypt        = true
  # }
}
