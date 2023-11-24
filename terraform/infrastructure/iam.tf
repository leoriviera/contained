# Create IAM user for access to S3 bucket
resource "aws_iam_user" "gh_action" {
  name = "gh_action"
}

# Create an IAM policy for S3 bucket access
resource "aws_iam_policy" "s3_access_policy" {
  description = "Allows access to S3 bucket created by Terraform for contained site"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowS3BucketAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::${var.s3_bucket_name}/*"
      }
    ]
  })
}

# Attach IAM policy to user
resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = aws_iam_user.gh_action.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# Generate access key
resource "aws_iam_access_key" "gh_action" {
  user = aws_iam_user.gh_action.name
}
