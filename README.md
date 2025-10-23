# 概要

これは私が日々の勉強で作成したプログラムです。

これまでは別々のリポジトリでしたが、プログラム数が増えてきたため、見やすくするために1つのリポジトリに統合しました。

各フォルダにはサンプルコードが含まれています。

詳しい手順については、各フォルダ内のREADME.mdファイルをご覧ください。

# プロジェクトの概要

- 001_drf_project
  - フロントエンド、バックエンド、IaC、CICD が同梱されているプロジェクト
  - フロントエンド: Next.js
  - バックエンドエンド: Django Rest Framework
  - IaC: Terraform
- 002_nextjs_project
  - Next.js の簡単なプログラム
  - GitHub Actions のワークフローが含まれており、`003_apprunner_terraform`と一緒に使うとインフラ側も実装可能
- 003_apprunner_terraform
  - AWS の App Runner を使用して Next.js を動かすインフラのコードを Terraform で実装
  - `002_nextjs_project` と一緒に使うとよし
- 004_operator_browser
  - ブラウザを AI で操作するための仕組み
- 005_neo4j
  - Neo4j のサンプルコード
- 006_ai_agent
  - LangGraph を使用した AI エージェントのチャットボット
- 007_stock_price_prediction_ai_verification
  - ゴールドの価格を予想する検証
  - まだ精度が良くない
- 008_transformers
  - Transformers のサンプルコード

#
