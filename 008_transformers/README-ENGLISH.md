# Overview

This project assumes using an NVIDIA GPU from Docker.

It is Windows-oriented. If you are on macOS or not using a GPU, adjust `docker-compose.yml` accordingly.

# Create Development Environment

## 1. Environment Variables

Create `.env.docker` from `.env.docker.example`.

Create `code/.env` from `code/.env.example`.

## 2. Build Docker

```
make init
```

# How to Run

```
make shell
pipenv run python src/train_ai.py
```

# Folders

- `code`
  - Program files
- `code/model_repo/models`
  - Trained models
- `code/model_repo/tokenizers`
  - Trained tokenizers

