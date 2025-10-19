# Terraform Environment Setup

The following steps describe how to create the environment from scratch.

## 1. Environment Configuration

1. Make the following files:

- Create `credentials/aws/config` by referring to `credentials/aws/config.example` (assumes SSO login).
- Create `infrastructures/terraform/src/aws/project/backend-config.prod.hcl` by referring to `infrastructures/terraform/src/aws/project/backend-config.hcl.example`.
- Create `infrastructures/terraform/src/aws/project/terraform.prod.tfvars` by referring to `infrastructures/terraform/src/aws/project/terraform.tfvars.example`.

## 2. Route53 Setup

### 1

```
make shell
make init
cd /project/aws/project/route53
terraform init -backend-config=../backend-config.hcl
terraform apply
```

### 2. DNS Settings

Reference: udemy

Assume you obtained a domain (example.com) via onamae.com.

For staging:

- stg-example.com

For production:

- example.com

Because these domain settings are shared between stg and prod, perform the following steps once.

Steps:

1) Configure ACM and Route53 (nameservers)

Create `terraform/common/route53/terraform.tfvars` by referring to:

`terraform/common/route53/terraform.tfvars.example`

Then run:

```
cd terraform/common/route53
terraform init -migrate-state && terraform apply -auto-approve
```

2) Configure DNS at onamae.com

Open the AWS console, go to Route53, and open the hosted zone you created.

Set the values of the record with type "NS" to the nameservers at onamae.com (remove the trailing dot).

3) Configure ACM CNAME at onamae.com

From the same screen as step 2, open ACM (either Tokyo or N. Virginia region is fine).

In onamae.com: "DNS 設定/転送設定" -> use DNS record settings.

Add the ACM CNAME to onamae.com DNS records (remove trailing dot).

Settings:

- "onamae.com host name" = "AWS record name"
- "onamae.com VALUE" = "AWS value/traffic destination"
- "onamae.com TYPE" = CNAME

Check nameservers:

```
nslookup -type=ns example.com
```

After these steps, wait a while. "Pending validation" should become "Issued".

## 3. Production Environment Setup

### 1. Environment files

- Create `infrastructures/terraform/src/aws/project/backend-config.prod.hcl` by referring to `infrastructures/terraform/src/aws/project/terraform.tfvars.example`.
- Create a GitHub fine-grained PAT (see below) and set it in `infrastructures/terraform/src/aws/project/terraform.prod.tfvars`.

### 2. Create resources

```
make shell
cd /project/aws/
make prod-apply
```

### 3. After apply

- Open the AWS console and register the project `.env` into SSM Parameter Store.
- CodePipeline -> Edit -> Edit Source stage -> Update pending connection -> Update connection -> Save
  - This may fail once; repeat if needed
  - Also refer to "Connect with GitHub" and complete the connection

## Connect with GitHub

Open the AWS account that has CodePipeline (not GitHub organizations).

CodePipeline -> Edit -> Edit Source stage -> Connect to GitHub -> Close the tab -> Update pending connection -> Update connection -> Save

Additionally, from stage edit, choose "Connect to GitHub" and configure.

## How to create a GitHub PAT (fine-grained)

Create a Fine-grained token:

profile settings > Developer Settings > Personal access tokens > tokens (classic)

Set the following:

- Appropriate name
- Appropriate repositories
- Appropriate permissions
  - Administration: Read and write
  - Webhooks: Read and write

## Future Work

1) Investigate the following:

- Tighten IAM permissions
- Tighten role permissions
- Improve GitHub integration flow

2) Reconsider VPC endpoints

Currently only ecr.dkr, ecr.api, and s3 are configured. Consider also logs, secretsmanager, ssm, and ssmmessages.

References:

https://dev.classmethod.jp/articles/vpc-endpoints-for-ecs-2022/

https://qiita.com/ldr/items/7c8bc08baca1945fdb50

3) Add stg environment (currently only prod). Consider multi-environment design with Terraform.

Reference: https://qiita.com/poly_soft/items/c71bb763035b2047d2db

4) Change app-to-RDS connection from password-based to role-based.

5) When running CI/CD, image builds may traverse NAT; verify.

# Command Memo

## terraform

```
terraform init -backend-config=../backend-config.hcl
```

## aws-cli

## List EC2 instances

```
aws --profile aws-prod ec2 describe-instances
```

## List RDS instances

```
aws --profile aws-prod rds describe-db-instances
```

## Bastion host - shell

```
aws ssm start-session \
--target i-xxx \
--document-name SSM-SessionManagerRunShell \
--profile aws-prod
```

## Bastion host - port forward

