locals {
  s3_origin_id = "s3_origin"
}

# Create origin access control policy for CloudFront bucket
resource "aws_cloudfront_origin_access_control" "s3_access" {
  name                              = aws_s3_bucket.bucket.bucket_domain_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Create a CloudFront distribution
resource "aws_cloudfront_distribution" "cloudfront" {
  enabled = true

  origin {
    origin_id                = local.s3_origin_id
    domain_name              = aws_s3_bucket.bucket.bucket_domain_name
    origin_path              = "/build"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_access.id
  }

  aliases = [var.frontend_domain]

  default_cache_behavior {
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cache_policy_id        = data.aws_cloudfront_cache_policy.caching_policy.id
    target_origin_id       = local.s3_origin_id
    cached_methods         = ["GET", "HEAD"]
  }

  default_root_object = "index.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.certificate.certificate_arn
    ssl_support_method  = "sni-only"
  }

  is_ipv6_enabled = true
}

# Create a record to point the front-end subdomain at the CloudFront distribution
resource "aws_route53_record" "frontend" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "${var.frontend_domain}."
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cloudfront.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront.hosted_zone_id
    evaluate_target_health = true
  }
}
