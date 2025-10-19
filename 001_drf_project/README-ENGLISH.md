# Note

This project is under active development, so the code may change frequently.

# Tech Stack

- Backend: Python Django REST framework
- Frontend: Next.js (App Router)
- Infrastructure: AWS
- IaC: Terraform
- Development environment: Docker

# Overview

This is a simple sample application where a user can register from the user UI, and an admin can edit the user from the admin UI.

These functions are common to many projects, so feel free to use this repository as a reference when building your own projects.

Formatters, static analysis, and debugging have also been incorporated.

I am still learning Django REST framework and Next.js, so apologies for any shortcomings.

# Development Environment

Both admin and user sides are available. The following URLs are mapped:

- Admin API: admin-api
  - http://localhost:8000/
- Admin API (Swagger): admin-api Swagger
  - http://localhost:8080/
- User API: user-api
  - http://localhost:8001/
- User API (Swagger): user-api Swagger
  - http://localhost:8081/
- Admin Frontend: admin-front
  - http://localhost:3000/
- User Frontend: user-front
  - http://localhost:3001/

## Sample Users

Admin side

admin1@example.com

test1234

User side

user1@example.com

test1234

## Environment Setup

Step 1

If Docker is not installed on your machine, please install Docker.

Official site: https://code.visualstudio.com/download

Step 2

Run the following commands to set up the Docker-based development environment.

```
make cp-env
make init
```

Step 3

How to start admin-api

```
make admin-api-run
```

Then open the following in your browser:

http://localhost:8000/docs

Step 4

How to start admin-front

```
make admin-front-run
```

Then open the following in your browser:

http://localhost:3000/

Step 5

How to start user-api

```
make user-api-run
```

Then open the following in your browser:

http://localhost:8001/

Step 6

How to start user-front

```
make user-front-run
```

Then open the following in your browser:

http://localhost:3001/

# About IaC

[Reference](https://github.com/campbel2525/sample-projects/blob/main/001_drf_project/infrastructures/terraform/README.md)

# Others

## Push Rules

Before pushing, while the containers are running, please run the command below.

It will run formatters and static analysis checks on both backend and frontend.

```
make check
```

## How to install backend (API) libraries

Using admin-api as an example:

Because Docker is used, when installing a module you need to enter the container and install it there.

Also, since pipenv is used for dependency management, installation requires a specific command.

Example: Install numpy

Step 1

Enter the container with the command below:

```
make admin-api-shell
```

Step 2

Install numpy with:

```
pipenv install numpy
```

## How to install frontend libraries

Using admin-front as an example:

Because Docker is used, when installing a module you need to enter the container and install it there.

Example: Install xxx

Step 1

Enter the container with the command below:

```
make admin-front-shell
```

Step 2

Install xxx with:

```
npm install xxx
```

### Create migration

```
pipenv run alembic revision --autogenerate -m 'comment'
```

### Migrate

```
pipenv run python manage.py migrate
```

or

```
make migrate
```

## function name of restapi

Please enter the name of each function below.

Anything is fine, but I used djangorest framework as a reference

https://www.django-rest-framework.org/api-guide/viewsets/

- List: index
- Get details: retrieve
- Create: create
- Update: update
- Delete: destroy

# Operation

## Branch operation

The expected branch will be as follows

- main branch: development
- (stg branch: staging branch)
- prod branch: production branch

## Deployment flow

The deployment flow is as follows:

1. Create a pull request for main branch -> prod branch

2. Tests are executed on github

3. Check that the tests completed correctly and merge them into the prod branch. This triggers the cicd below to be executed.

4. Both the front and back ends are built

5. Build the admin-api for migration and run the migration (Building here is useless. Why not just use what was built in the previous step?)

6. Deploy each of the above four projects
