# Forum App – Terraform V2 starter

This starter provisions a custom VPC, two public subnets, two private subnets,
an Internet Gateway, one NAT Gateway, security groups, an internet-facing ALB,
a Launch Template, an EC2 IAM role/profile, and an Auto Scaling Group.

The frontend S3/CloudFront distribution and Route 53 records are intentionally
not managed here yet. First validate the backend on the new ALB, then add those
resources in a later stage.

## Prerequisites

- Terraform 1.6+
- AWS CLI configured for the intended AWS account/profile
- A publicly cloneable backend repository
- An SSM Parameter Store `SecureString` containing the complete application
  `.env` file (one `KEY=value` per line), at the name in `env_parameter_name
- MongoDB Atlas configured to allow the NAT Gateway's Elastic IP

## Prepare the secret

Create a SecureString parameter in the same AWS region, for example:

`/forum-v2/production/env`

Its value should be the full contents of your backend `.env` file. Do not commit
that value, `terraform.tfvars`, or Terraform state to Git.

The EC2 instance role receives permission to read only this parameter and the
standard permissions required by Systems Manager Session Manager.

## Configure and deploy

1. Copy `terraform.tfvars.example` to `terraform.tfvars`.
2. Set the real backend repository URL and AWS region.
3. Check that the AWS CLI is using the intended account:
   `aws sts get-caller-identity`
4. Run:

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

Review the plan before applying. This creates billable resources, including a
NAT Gateway and an ALB.

## Test

Use the `alb_dns_name` output to test the API. Check the ASG and target group
for healthy instances. On an instance, inspect `/var/log/user-data.log` and
`pm2 status` using Session Manager.

## Important assumptions to verify

- The backend listens on port 3000.
- `npm ci` succeeds (the repository has a package-lock.json).
- `npm start` starts the production server.
- The app reads its environment from `/opt/forum-app/.env`.
- The app responds successfully to `GET /` for the ALB health check.
- The repository is public. Private GitHub repositories need a secure
  authentication/deployment approach; do not put a GitHub token in user data.
- The SSM parameter contains every required environment variable.
- Atlas allows the NAT Gateway Elastic IP shown by Terraform output.

## Cost and availability notes

This starter intentionally uses one NAT Gateway to reduce learning costs.
That means private-subnet outbound traffic depends on that NAT Gateway/AZ.
For production-style multi-AZ egress resilience, use one NAT Gateway per AZ
and route each private subnet through its same-AZ NAT Gateway.

The ALB, NAT Gateway, EC2 instances, EBS volumes, and data transfer can incur
charges. Destroy this V2 environment when not using it, after checking that
you are not destroying resources you need.
