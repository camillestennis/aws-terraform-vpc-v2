# AWS Terraform Portfolio Project

Infrastructure-as-code project provisioning a small AWS environment entirely with Terraform.

## What it builds
- VPC with a public subnet
- Internet gateway + route table
- Security group (SSH from anywhere, HTTP from anywhere — tightened for a portfolio demo, not production)
- EC2 instance (t3.micro, Amazon Linux 2) running Apache
- S3 bucket

## Usage

```
terraform init
terraform plan
terraform apply
```

Outputs the instance's public IP (\`instance_public_ip\`) after apply.

## Notes
Built as a hands-on demonstration of provisioning AWS resources as code rather than through the console, as part of a cloud engineering portfolio.
