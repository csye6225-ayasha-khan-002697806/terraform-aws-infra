# IAM Role and Policy for ec2 instance
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
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket.bucket}",  # Correctly reference the bucket name
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket.bucket}/*" # Access to all objects in the bucket
        ]
      }
    ]
  })
}

# Attach CloudWatch policies to the IAM role
data "aws_iam_policy" "cloudwatch_agent_policy" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_bucket_policy.arn
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


# Policy for Load Balancer access
# resource "aws_iam_policy" "load_balancer_policy" {
#   name        = "LoadBalancerPolicy"
#   description = "Policy to allow Load Balancer access"
#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Effect" : "Allow",
#         "Action" : [
#           "elasticloadbalancing:Describe*",
#           "elasticloadbalancing:RegisterTargets",
#           "elasticloadbalancing:DeregisterTargets",
#           "elasticloadbalancing:ModifyTargetGroup"
#         ],
#         "Resource" : "*"
#       }
#     ]
#   })
# }

# # Attach Load Balancer Policy to EC2 Role
# resource "aws_iam_role_policy_attachment" "attach_load_balancer_policy" {
#   role       = aws_iam_role.ec2_role.name
#   policy_arn = aws_iam_policy.load_balancer_policy.arn
# }


resource "aws_iam_role_policy" "secrets_manager_access" {
  name = "SecretsManagerAccessPolicy"
  role = aws_iam_instance_profile.ec2_profile.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow"
        Action   = "secretsmanager:GetSecretValue"
        Resource = "*"
      }
    ]
  })
}
