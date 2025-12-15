terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.18.0"
    }
  }

  # backend "s3" {
  #   bucket         = "vignan-tfstate-1234-bucket"
  #   key            = "./terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "STATE_LOCKING_TABLE"
  #   encrypt        = true
    
  # }

}