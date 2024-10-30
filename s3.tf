# s3.tf

# Randomly generated UUID for bucket name
resource "random_uuid" "s3_bucket_uuid" {}

# Create an S3 bucket without ACL settings
resource "aws_s3_bucket" "csye6225_bucket" {
  bucket        = random_uuid.s3_bucket_uuid.result
  force_destroy = true

  tags = {
    Name = "csye6225-s3-bucket"
  }
}

# Define Public Access Block configuration to make bucket private
resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket                  = aws_s3_bucket.csye6225_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
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
