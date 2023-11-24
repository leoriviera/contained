# contained

A blog made of containers!

![Screenshot of contained](https://github.com/leoriviera/contained/blob/26726c04fd069ff7e083b66ddd624047b0ec9503/blog.png)

## Prerequisites

- An already-configured hosted zone for your domain of choice on Route 53
- Terraform, for IaC configuration
- An authenticated AWS CLI, which Terraform uses to deploy infrastructure
- An authenticate GitHub CLI, which Terraform uses to deploy infrastructure

## Getting Started

1. Run the `publish-images` GitHub Action, to push `contained` images to GHCR
2. Locally set up infrastructure with Terraform, using `terraform apply`
3. Run the `publish-frontend` GitHub Action
4. Visit your site, and enjoy!

## Architecture Overview

Below is an architecture diagram of the infrastructure that this project deploys. The VPC, internet gateway, subnets and security groups have been omitted from the diagram for the sake of clarity.

![Architecture diagram](https://github.com/leoriviera/contained/blob/f9e551e87bcddc3b4c7ea0cdaa49a317f87f5bed/contained.svg)

The various components include

1. A Route 53 Hosted Zone (which must be set up manually)
2. A CloudFront distribution, which serves the frontend
3. An S3 bucket, which stores the frontend (and is the origin for the CloudFront distribution)
4. An application load balancer, which routes traffic to the backend
5. An auto scaling group, which runs the backend and ensures there is at least one healthy instance running at all times
6. An instance of the backend, which runs the blog
7. AWS Certificate Manager, which issues certificates for the domain
8. GitHub Container Registry, which stores images for the backend and sibling SSH server
9. A GitHub Actions workflow with an IAM user for pushing the frontend to S3

## Features

- Creates a blog users can interact with via a web-based terminal
- Includes a good local development experience, including hot reloading for the primary server
- Infrastructure as code defined using Terraform
- Deployment pipelines defined using GitHub Actions

## Contributing

To contribute, you'll need the prerequisites listed above, along with the following installed on your machine.

- Docker, for containers. Docker Desktop is also helpful.

## Roadmap

Future work for this project could involve

- [ ] Switch `packages/` to a monorepo using Nx or a similar tool
- [ ] Deploying infrastructure with GitHub Actions, transitioning away from the default Terraform backend
- [ ] Adding syntax highlighting into the terminal, possibly through a utility that adds colour to code blocks
- [ ] Making scrolling on mobile smoother
- [ ] Updating the dimensions of the remote serial console to match the dimensions of the user's screen
- [ ] Handle SIGTERM in `server` (gracefully shut down, stop accepting new connections, close SSH servers)
