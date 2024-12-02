# Generate a UUID for the S3 bucket name
resource "random_uuid" "bucket_name" {}

# S3 Bucket with UUID as name
resource "aws_s3_bucket" "s3_bucket" {
  bucket        = "terraform-${random_uuid.bucket_name.result}" # Use the generated UUID as the bucket name
  force_destroy = true
}


# Block public access settings for the S3 bucket
resource "aws_s3_bucket_public_access_block" "s3_private_bucket" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Lifecycle policy for transition to STANDARD_IA storage class
resource "aws_s3_bucket_lifecycle_configuration" "private_bucket_lifecycle" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    id     = "TransitionRule"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}


# Server-side encryption configuration for S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encrypt" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      # sse_algorithm = "AES256"
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_kms_key.arn
    }
  }
}