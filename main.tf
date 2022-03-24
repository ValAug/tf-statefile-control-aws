#--main/root--

resource "aws_s3_bucket" "bucket_state" {
  bucket        = var.bucket_name # REPLACE WITH YOUR BUCKET NAME
  force_destroy = true
}

resource "aws_s3_bucket" "bucket_test_name" {
  bucket = var.test == true ? "dev" : "prod" # REPLACE WITH YOUR BUCKET NAME
  force_destroy = true
}



resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket_state.id
  versioning_configuration {
    status = "Enabled"
  }

}

resource "aws_s3_bucket_public_access_block" "bucket_block_pub_access" {
    bucket = aws_s3_bucket.bucket_state.id
    
    block_public_acls   = true
    block_public_policy = true

}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_side_encryption" {
  bucket = aws_s3_bucket.bucket_state.id

  rule {
    apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.ddb_table_name 
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
        enabled = true
    }
}