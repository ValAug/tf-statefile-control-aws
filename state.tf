terraform {
  backend "s3" {
    bucket         = "devops-share-tf-state"
    key            = "sharestatefile/terraform.tfstate"
    region         = "ca-central-1"
    dynamodb_table = "terraform-state-control"
    encrypt        = true
  }
}