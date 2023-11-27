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
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.bucket.arn}/*"
      }
    ]
  })
}

# Attach IAM policy to user
resource "aws_iam_user_policy_attachment" "s3_user_access" {
  user       = aws_iam_user.gh_action.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# Generate access key
resource "aws_iam_access_key" "gh_action" {
  user = aws_iam_user.gh_action.name
}

data aws_iam_policy_document "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_iam_role" {
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "s3_user_access" {
  role = aws_iam_role.ec2_iam_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  role = aws_iam_role.ec2_iam_role.name
}
