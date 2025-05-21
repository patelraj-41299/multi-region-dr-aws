terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "multi-region-dr-tfstate"
    key            = "state/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "terraform-locks"  # Optional: for state locking
  }
}

# Default provider (for general use, us-east-2)
provider "aws" {
  region = "us-east-2"
}

# Primary region (for S3 primary, us-east-1)
provider "aws" {
  alias  = "primary"
  region = "us-east-1"
}

# Secondary region (for S3 secondary, us-west-2)
provider "aws" {
  alias  = "secondary"
  region = "us-west-2"
}
