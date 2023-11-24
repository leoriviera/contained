output "frontend_domain" {
  value = "${var.frontend_subdomain}.${var.domain}"
}

output "server_subdomain" {
  value = "${var.server_subdomain}.${var.domain}"
}

output "s3_bucket_name" {
  value = module.frontend.s3_bucket_name
}
