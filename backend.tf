terraform {
  backend "s3" {
    bucket         = "tf-state-file-20251205"  # Your S3 bucket name
    key            = "infra/terraform.tfstate"   # Path to the state file
    region         = "us-east-1"               # S3 bucket region
    dynamodb_table = "tf-lock-table-20251204"  # DynamoDB state lock table
    encrypt        = true                      # Encrypt state file at rest
  }
}