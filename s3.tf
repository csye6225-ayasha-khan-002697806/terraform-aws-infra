# s3.tf

# Randomly generated UUID for bucket name
resource "random_uuid" "s3_bucket_uuid" {}

# Create an S3 bucket without ACL settings (since ACL is set separately)
resource "aws_s3_bucket" "csye6225_bucket" {
  bucket        = random_uuid.s3_bucket_uuid.result
  force_destroy = true # Allows Terraform to delete the bucket even if it's not empty

  tags = {
    Name = "csye6225-s3-bucket"
  }
}

# Define ACL configuration for the S3 bucket
resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.csye6225_bucket.bucket
  acl    = "private"
}

# Define server-side encryption configuration for the S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.csye6225_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Define versioning configuration for the S3 bucket
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.csye6225_bucket.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

# Define lifecycle configuration for the S3 bucket
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.csye6225_bucket.bucket

  rule {
    id     = "transition_to_IA"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }

  rule {
    id     = "abort_multipart_uploads"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

