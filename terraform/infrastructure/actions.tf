resource "github_repository_environment" "repo_env" {
  environment = "production"
  repository  = data.github_repository.repo.name
}

resource "github_actions_environment_variable" "server_domain" {
  environment   = github_repository_environment.repo_env.environment
  repository    = data.github_repository.repo.name
  variable_name = "REACT_APP_SERVER_DOMAIN"
  value         = var.server_domain
}

resource "github_actions_environment_variable" "frontend_domain" {
  environment   = github_repository_environment.repo_env.environment
  repository    = data.github_repository.repo.name
  variable_name = "REACT_APP_FRONTEND_DOMAIN"
  value         = var.frontend_domain
}

resource "github_actions_environment_variable" "aws_s3_bucket_name" {
  environment   = github_repository_environment.repo_env.environment
  repository    = data.github_repository.repo.name
  variable_name = "AWS_S3_BUCKET_NAME"
  value         = aws_s3_bucket.bucket.bucket
}

resource "github_actions_environment_variable" "aws_region" {
  environment   = github_repository_environment.repo_env.environment
  repository    = data.github_repository.repo.name
  variable_name = "AWS_REGION"
  value         = var.aws_region
}

resource "github_actions_environment_secret" "aws_access_key_id" {
  environment     = github_repository_environment.repo_env.environment
  repository      = data.github_repository.repo.name
  secret_name     = "AWS_ACCESS_KEY_ID"
  plaintext_value = aws_iam_access_key.gh_action.id
}

resource "github_actions_environment_secret" "aws_secret_access_key" {
  environment     = github_repository_environment.repo_env.environment
  repository      = data.github_repository.repo.name
  secret_name     = "AWS_SECRET_ACCESS_KEY"
  plaintext_value = aws_iam_access_key.gh_action.secret
}
