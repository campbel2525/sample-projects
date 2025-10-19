# Overview

This repository collects programs I’ve built as part of my daily study.

Each folder contains a sample piece of code.

These used to live in separate repositories, but as the number grew I consolidated them into a single repo to make things easier to browse.

# Project Overview

- 001_drf_project
  - A project bundling the frontend, backend, IaC, and CI/CD
  - Frontend: Next.js
  - Backend: Django REST Framework
  - IaC: Terraform
- 002_nextjs_project
  - A simple Next.js application
  - Includes GitHub Actions; when used together with `003_apprunner_terraform`, you can implement the infrastructure side as well
- 003_apprunner_terraform
  - Terraform code for infrastructure that runs a Next.js app on AWS App Runner
  - Works well in combination with `002_nextjs_project`
- 004_operator_browser
  - A system for controlling a browser with AI (AI-driven browser automation)
- 005_neo4j
  - Sample code for Neo4j
- 006_ai_agent
  - A chatbot AI agent built with LangGraph
- 007_stock_price_prediction_ai_verification
  - An experiment to forecast gold prices
  - Accuracy is not yet satisfactory
- 008_transformers
  - Transformer sample code
