data "aws_cloudfront_cache_policy" "caching_policy" {
  name = "Managed-CachingOptimized"
}

variable "certificate_arn" {
  type     = string
  nullable = false
}

variable "hosted_zone_id" {
  type     = string
  nullable = false
}

variable "domain" {
  type     = string
  nullable = false
}

variable "iam_user_arn" {
  type     = string
  nullable = false
}
