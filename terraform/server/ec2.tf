# Upload docker-compose.yml to S3
resource "aws_s3_object" "docker_compose" {
  bucket = var.s3_bucket_name
  key    = "config/docker-compose.yml"
  source = "${path.module}/docker-compose.yml"
  etag   = filemd5("${path.module}/docker-compose.yml")
}



# data aws_iam_policy_document "s3_read_access" {
#   statement {
#     actions = ["s3:Get*", "s3:List*"]
#     resources = ["arn:aws:s3:::*"]
#   }
# }


# resource "aws_iam_role_policy" "s3_read_access" {
#   role       = aws_iam_role.ec2_iam_role.name
#   policy = data.aws_iam_policy_document.s3_read_access.json
# }

# resource "aws_iam_role_policy_attachment" "s3_read_access" {
#   role       = aws_iam_role.ec2_iam_role.name
#   policy_arn =aws_iam_policy.s3_read_access.arn
# }
