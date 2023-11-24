# Terraform

This Terraform config includes

Employs module composition

https://www.terraform.io/docs/modules/composition.html

To deploy using GitHub Actions, you'll need to get the infrastructure up and running using Terraform.

Ensure you've got the following installed, so you can run the Terraform scripts.

- an authenticated AWS CLI (log in with `aws sso login --profile my-profile`)
- an authenticated GitHub CLI (log in with `gh auth login`)

You'll then need to

1. Download the necessary providers and modules using `terraform init`
2. Deploy the infrastructure using `terraform apply`

This

1. sets up the necessary infrastructure (IAM accounts, GitHub Actions secrets, ACM certificates)
2. configures everything necessary to host the frontend (Route 53 records, S3 bucket, CloudFront)
3. configures everything necessary to host the backend (ALB, ASG, launch templates, security groups)

## Variables

You'll need to configure some variables to deploy to your own infrastructure.

- `region`: the AWS region you want to set up your resources in. This defaults to `us-east-1`. However, ACM certificates are always created in `us-east-1`, as CloudFront can only use certificates from that region.
- `domain`: the "base domain" you want to use for your blog. For example, if you want to use `blog.example.com`, you'd set this to `example.com`.
- `frontend_subdomain`: the subdomain you want users to visit to access your blog. For example, if you want to use `blog.example.com`, you'd set this to `blog`. This defaults to `sh`.
- `server_subdomain`: the subdomain you want to use for the backend. For example, if you want to use `blog.example.com`, you'd set this to `server`.
- `instance_type`: the instance type to use in your ASG. This defaults to `t3.micro`. These Terraform scripts will spin up an ASG in subnets in regions where the instance type is available.
- `repository`: the GitHub repository for the project. This is used for GitHub Actions secrets. This defaults to `leoriviera/contained`.

`terraform init`, to download the necessary providers.
`terraform apply`, to deploy the infrastructure.
