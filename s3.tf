# # s3.tf

# Generate a UUID for the S3 bucket name
resource "random_uuid" "bucket_name" {}

# IAM Role and Policy for S3 and Cloud Watch
resource "aws_iam_role" "ec2_role" {
  name = "IAMRoleForEc2"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# Policy for managing the S3 bucket
resource "aws_iam_policy" "s3_bucket_policy" {
  name        = "S3BucketPolicy"
  description = "Policy for managing the S3 bucket"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:PutBucketEncryption",
          "s3:PutLifecycleConfiguration"
        ],
        "Resource" : [
          "arn:aws:s3:::${random_uuid.bucket_name.result}",
          "arn:aws:s3:::${random_uuid.bucket_name.result}/*"
        ]
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_bucket_policy.arn
}

# S3 Bucket with UUID as name
resource "aws_s3_bucket" "s3_bucket" {
  force_destroy = true
}

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

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encrypt" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Attach CloudWatch policies to the IAM role
data "aws_iam_policy" "cloudwatch_agent_policy" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Attach the IAM policy to the IAM role
resource "aws_iam_role_policy_attachment" "attach_cloudwatch_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = data.aws_iam_policy.cloudwatch_agent_policy.arn
}

resource "aws_iam_policy" "statsd_cloudwatch_policy" {
  name        = "StatsDCloudWatchPolicy"
  description = "Policy for publishing custom StatsD metrics to CloudWatch"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "cloudwatch:PutMetricData"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "cloudwatch:namespace" : "StatsD"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_statsd_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.statsd_cloudwatch_policy.arn
}
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
}