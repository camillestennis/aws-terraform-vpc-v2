# AWS Terraform Portfolio Project (v2)

Infrastructure as code project provisioning a small, multi AZ AWS network environment entirely with Terraform.

This is the hardened, networking focused follow up to the original single AZ build (v1, [aws-terraform-vpc](https://github.com/camillestennis/aws-terraform-vpc)).

## What it builds

- VPC (`10.0.0.0/16`) spanning two Availability Zones (`us-west-1a` and `us-west-1c`)
- Public subnets in both AZs, each with a route to an Internet Gateway
- Private subnets in both AZs, routed out through a NAT Gateway for outbound internet access with no direct inbound exposure
- Security group scoped to the deployer's own IP for SSH, with HTTP open for web traffic
- EC2 instance (t3.micro, Amazon Linux 2023, looked up dynamically via the latest AMI rather than a hardcoded image ID)
- S3 bucket with a randomized suffix to avoid naming collisions
- Consistent tagging (`Environment`, `ManagedBy`) across all resources

## Why multi AZ and NAT

A single AZ, single subnet build proves you can provision infrastructure as code. This version goes further by modeling how a real network is actually laid out: public and private tiers, redundancy across Availability Zones, and a NAT Gateway so private resources can reach the internet for updates without being directly reachable from it.

## Usage

terraform init
terraform plan
terraform apply


Requires a `terraform.tfvars` file (not committed, see `.gitignore`) defining:

my_ip = "YOUR_IP/32"
environment = "portfolio"
aws_region = "us-west-1"


Also requires an EC2 key pair named `portfolio-key` to already exist in the target region.

Outputs the instance's public IP (`instance_public_ip`) after apply.

## Notes

Built as a hands on demonstration of network design and provisioning as code, as part of a cloud and network infrastructure portfolio. The security group intentionally restricts SSH to a single IP rather than leaving it open, since the point of this build is to show deliberate access control, not just a working instance.

Remember to run `terraform destroy` when not actively using the deployed environment. The NAT Gateway incurs hourly charges and is not covered by the AWS Free Tier.