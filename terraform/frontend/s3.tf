# Create S3 bucket
resource "aws_s3_bucket" "bucket" {
  force_destroy = true
}

# Allow access to the S3 bucket through CloudFront
resource "aws_s3_bucket_policy" "allow_cloudfront_access" {
  bucket = aws_s3_bucket.bucket.id
  policy = jsonencode({
    Version = "2008-10-17"
    Id      = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action   = "s3:GetObject",
        Resource = "${aws_s3_bucket.bucket.arn}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cloudfront.arn
          }
        }
      },
      {
        Sid = "AllowS3BucketAccess",
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.bucket.arn}/*",
        Principal = {
          AWS = [
            var.iam_user_arn
          ]
        }
      },
      {
        Sid = "AllowS3BucketAccess",
        Effect = "Allow",
        Action = [
          "s3:ListBucket"
        ]
        Resource = "${aws_s3_bucket.bucket.arn}",
        Principal = {
          AWS = [
            var.iam_user_arn
          ]
        }
      }
    ]
  })
}
