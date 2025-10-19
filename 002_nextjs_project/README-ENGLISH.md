# Additional Notes

When used together with the Terraform project [003_apprunner_terraform](https://github.com/campbel2525/sample-projects/tree/main/003_apprunner_terraform), both the Next.js application and its infrastructure setup are completed.

# Sample Next.js Monorepo Project

This project is a sample monorepo using Next.js and Prisma.
The development environment runs on Docker and can be controlled with simple `make` commands.

## Tech Stack

- Frontend: Next.js, React, TypeScript
- Backend: Next.js (API Routes)
- ORM: Prisma
- Database: MySQL
- Container: Docker, Docker Compose
- CI/CD: GitHub Actions, AWS App Runner
- Lint/Format: ESLint, Prettier

## Local Development Setup

1. Set environment files

   Run the following in the repository root to copy sample environment files:

   ```bash
   make cp-env
   ```

2. Build and start the environment

   This will build Docker containers, set up the DB, and install dependencies:

   ```bash
   make init
   ```

3. Verify

   When setup completes, open http://localhost:3001 in your browser.
   If you can log in with the credentials below, setup is successful:

   - Email: `user1@example.com`
   - Password: `test1`

## Useful Make Commands

This project provides `make` commands wrapping `docker compose` operations.

| Command                  | Description                                                 |
| ------------------------ | ----------------------------------------------------------- |
| `make help`              | Lists all available commands.                               |
| `make up`                | Starts the development environment.                         |
| `make down`              | Stops the development environment.                          |
| `make reset`             | Resets the DB and re-seeds initial data.                    |
| `make check`             | Runs formatting and static analysis across all workspaces.  |
| `make user-front-shell`  | Opens a shell in the `user_front` container.                |
| `make migration-shell`   | Opens a shell in the `migration` container.                 |

For other commands, see the `Makefile` or run `make help`.

### Installing Packages

To add a library to a specific workspace, use the `-w` option.

```bash
# Example: install a library into the user_front workspace
npm install <library-name> -w user_front
```

## Directory Structure

This repository uses an npm workspaces-based monorepo.

- `apps`: Application packages
  - `user_front`: Frontend app built with Next.js
  - `migration`: Development scripts for DB migration and seeding
- `packages`: Shared packages
  - `db`: Prisma client, schema, and migrations
  - `factories`: Factory-like utilities for test data
  - `seeders`: Database seeders
  - `tsconfig`: Shared TypeScript configuration
- `docker`: Docker-related configs
  - `local`: Local development Docker Compose and related files
  - `github_action`: Dockerfile for AWS App Runner deployment

```
.
├── apps
│   ├── migration
│   └── user_front
├── packages
│   ├── db
│   │   └── prisma
│   │       └── migrations
│   ├── factories
│   ├── seeders
│   └── tsconfig
├── docker
│   ├── github_action
│   └── local
├── .github/workflows
│   └── cicd.yml
├── Makefile
├── package.json
└── README.md
```

## CI/CD

GitHub Actions deploys to AWS App Runner when changes are pushed to specific branches.

### Branch Strategy

- `main`: Primary development branch
- `stg`: Staging branch; deployments run when `main` is merged here
- `prod`: Production branch; deployments run when `stg` is merged here

Flow: `main` -> `stg` -> `prod`

### Setup Steps

1. Prepare AWS resources

   Provision AWS App Runner, ECR, etc. You can use:
   - https://github.com/campbel2525/sample-projects/tree/main/003_apprunner_terraform

2. Configure GitHub Secrets

   After `terraform apply`, set the following outputs as GitHub Secrets under `Environments` > `stg` (or `prod`):

   | Terraform Output Key                 | GitHub Secret Name               |
   | ----------------------------------- | -------------------------------- |
   | `AWS_REGION`                         | `ap-northeast-1`                 |
   | `IAM_ROLE`                           | `github_actions_iam_role`        |
   | `MIGRATION_BATCH_JOB_DEFINITION_NAME`| `migration_job_definition_name`  |
   | `MIGRATION_BATCH_JOB_QUEUE_NAME`     | `migration_job_queue_name`       |
   | `MIGRATION_ECR_REPOSITORY_NAME`      | `migration_ecr_name`             |
   | `USER_FRONT_APPRUNNER_ARN`           | `user_front_apprunner_arn`       |
   | `USER_FRONT_ECR_REPOSITORY_NAME`     | `user_front_ecr_name`            |

3. Set application environment variables

   Refer to `apps/user_front/.env.example` and `apps/migration/.env.example`, then set required variables in AWS Systems Manager (SSM) Parameter Store.

4. Deploy

   Push to the `stg` branch to trigger the workflow and deploy to staging automatically.
