# Supplement

Use this together with the Next.js project [002_nextjs_project](https://github.com/campbel2525/sample-projects/tree/main/002_nextjs_project) to complete both the Next.js application and the surrounding infrastructure.

# AWS App Runner on Terraform

This is a Terraform project for deploying an application built with Next.js to AWS App Runner.

## Infrastructure Diagram

<img width="1564" height="1296" alt="image" src="https://github.com/user-attachments/assets/fc27b099-8614-4388-adf8-a09bb0cbece0" />
## Prerequisites

- [Docker](https://www.docker.com/)
- [make](https://www.gnu.org/software/make/)

## Setup

1. **Configure AWS SSO**:
   Enable SSO in your AWS account.
2. **Create an S3 Bucket**:
   Create an S3 bucket on AWS to store the Terraform state file.
3. **Set AWS Credentials**:
   Create `credentials/aws/config` by referring to `credentials/aws/config.example`.
4. **Initialize**:
   Run `make init` to build the Docker image and perform other initializations.

## Deployment Steps (Staging Environment Example)

1.  **Create Backend Configuration File**:
    Copy `src/project/backend-config.stg.hcl.example` to create `src/project/backend-config.stg.hcl`. For `bucket`, specify the S3 bucket name created in setup step 2.
2.  **Create Variable File**:
    Copy `src/project/terraform.stg.tfvars.example` to create `src/project/terraform.stg.tfvars` and set the variables according to your environment.
3.  **Enter the Docker Container**:
    Run `make shell` to enter the container for executing Terraform.

        **The following steps are executed inside the Docker container.**

4.  **Navigate to the Project Directory**:

    ```
    cd /project/project
    ```

5.  **Log in to AWS**:
    Log in to AWS with SSO.

        ```
        sl
        ```

6.  **Run Terraform**:
    Build the infrastructure in the staging environment.

        ```
        make stg-apply
        ```

        To destroy the infrastructure, run `make stg-destroy`.

7.  **Verify Operation**:
    Access the App Runner default domain output in the console. If the sample page is displayed, the deployment is successful.
    (At this point, the AWS-provided sample image `public.ecr.aws/aws-containers/hello-app-runner` is deployed).
8.  Based on the values output to the console, set the environment variables appropriately for the application.

## Command Reference

### Get Thumbprint for GitHub Actions OIDC

This retrieves the thumbprint required when connecting to AWS from GitHub Actions via OIDC.

```
openssl s_client -connect token.actions.githubusercontent.com:443 -showcerts \
 </dev/null 2>/dev/null \
 | openssl x509 -noout -fingerprint -sha1 \
 | sed 's/://g' | sed 's/SHA1 Fingerprint=//'
```

_Note: When setting this in environment variables, etc., please convert the result to lowercase._

## Additional Notes

### About the Initial App Runner Deployment

When a new App Runner service is created with `terraform apply`, a deployment is always triggered. This will result in an error if the container image to be deployed does not exist in ECR.

Therefore, the infrastructure must be built in the following steps:

1.  **Create ECR Repository**:
    First, create only the ECR repository.

        ```
        # (Example)
        terraform apply -auto-approve -target=module.user_front_apprunner.aws_ecr_repository.app -var-file=../terraform.stg.tfvars
        ```

2.  **Push a Sample Image**:
    Push the AWS-provided sample image to the created ECR repository.
    The specific process is described in `push_initial_image.sh`.

        ```
        # (Example)
        ./push_initial_image.sh aws-stg ap-northeast-1 user-front-repo
        ```

3.  **Create App Runner Service**:
    With the image pushed to ECR, apply all resources, including App Runner.

        ```
        # (Example)
        terraform apply -auto-approve -var-file=../terraform.stg.tfvars
        ```

The `stg-apply` target in `src/project/Makefile` is configured to execute these steps automatically.

# Command Memo

This is an example for the stg environment.

## terraform

```
terraform init -backend-config=../backend-config.hcl
```

## AWS CLI

## List EC2 Instances

```
aws --profile aws-stg ec2 describe-instances
```

## List RDS Instances

```
aws --profile aws-stg rds describe-db-instances
```
