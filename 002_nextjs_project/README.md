[english version](https://github.com/campbel2525/sample-projects/blob/main/002_nextjs_project/README-ENGLISH.md)


# 補足

Terraform のプロジェクト[003_apprunner_terraform](https://github.com/campbel2525/sample-projects/tree/main/003_apprunner_terraform)と合わせて使用すると Next.js のアプリケーション、インフラ周りが完了します

# Sample Next.js Monorepo Project

このプロジェクトは、Next.jsとPrismaを使用したモノレポ構成のサンプルです。
開発環境はDockerで構築されており、`make`コマンドで簡単に操作できます。

## 主要技術

- **Frontend**: Next.js, React, TypeScript
- **Backend**: Next.js (API Routes)
- **ORM**: Prisma
- **Database**: MySQL
- **Container**: Docker, Docker Compose
- **CI/CD**: GitHub Actions, AWS App Runner
- **Lint/Format**: ESLint, Prettier

## ローカル開発環境のセットアップ

1.  **環境変数の設定**

    リポジトリのルートディレクトリで以下のコマンドを実行し、環境変数のサンプルファイルをコピーします。

    ```bash
    make cp-env
    ```

2.  **開発環境の構築と起動**

    以下のコマンドを実行すると、Dockerコンテナのビルド、データベースのセットアップ、依存パッケージのインストールが自動的に行われます。

    ```bash
    make init
    ```

3.  **動作確認**

    セットアップが完了したら、ブラウザで [http://localhost:3001](http://localhost:3001) にアクセスしてください。
    以下の情報でログインできれば、環境構築は成功です。
    - **Email**: `user1@example.com`
    - **Password**: `test1`

## 便利なコマンド (Makefile)

このプロジェクトでは、煩雑な`docker compose`コマンドをラップした`make`コマンドを提供しています。

| コマンド                | 説明                                                                 |
| ----------------------- | -------------------------------------------------------------------- |
| `make help`             | 利用可能なすべてのコマンドとその説明を表示します。                   |
| `make up`               | 開発環境（Dockerコンテナ）を起動します。                             |
| `make down`             | 開発環境を停止します。                                               |
| `make reset`            | データベースをリセットし、初期データを再投入します。                 |
| `make check`            | すべてのワークスペースでコードのフォーマットと静的解析を実行します。 |
| `make user-front-shell` | フロントエンド (`user_front`) のコンテナ内でシェルを起動します。     |
| `make migration-shell`    | スクリプト (`migration`) 用のコンテナ内でシェルを起動します。          |

その他のコマンドについては`Makefile`を参照するか、`make help`を実行してください。

### パッケージのインストール

特定のワークスペースにライブラリを追加する場合は、`-w`オプションを使用します。

```bash
# 例: user_front ワークスペースにライブラリをインストール
npm install <ライブラリ名> -w user_front
```

## ディレクトリ構成

このリポジトリは、npm workspacesを利用したモノレポ構成を採用しています。

- `apps`: 各アプリケーションが格納されています。
  - `user_front`: Next.jsで構築されたフロントエンドアプリケーションです。
  - `migration`: DBのマイグレーションやシード投入など、開発用のスクリプトが格納されています。
- `packages`: 複数のアプリケーションで共有されるパッケージが格納されています。
  - `db`: Prisma client、スキーマ定義、マイグレーションファイルが格納されています。
  - `factories`: テストデータを作成するためのFactoryBotのような機能を提供します。
  - `seeders`: データベースに初期データを投入するためのシーダーが格納されています。
  - `tsconfig`: 共有のTypeScript設定が格納されています。
- `docker`: Docker関連の設定ファイルが格納されています。
  - `local`: ローカル開発環境用のDocker Composeファイルなどが格納されています。
  - `github_action`: AWS App Runnerへのデプロイ用のDockerfileが格納されています。

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

GitHub Actionsを利用して、特定のブランチへのプッシュをトリガーにAWS App Runnerへ自動デプロイされます。

### ブランチ戦略

開発は`main`ブランチをベースに行います。各環境へのデプロイフローは以下の通りです。

- **`main`**: 開発ブランチ。このブランチへのマージが開発の基本となります。
- **`stg`**: ステージング環境用ブランチ。`main`ブランチからマージされると、ステージング環境にデプロイされます。
- **`prod`**: 本番環境用ブランチ。`stg`ブランチからマージされると、本番環境にデプロイされます。

フロー: `main` -> `stg` -> `prod`

### 設定手順

1.  **AWSリソースの準備**

    デプロイ先となるAWS App RunnerやECRなどのリソースを準備します。
    以下のTerraformリポジトリを使用すると、必要なリソース一式を構築できます。
    - [003_apprunner_terraform](https://github.com/campbel2525/sample-projects/tree/main/003_apprunner_terraform)

2.  **GitHub Secretsの設定**

    Terraformのapply後に出力される以下の値を、GitHubリポジトリの`Environments` > `stg` (または `prod`) のSecretsに設定してください。

    | Terraform Output Key             | GitHub Secret Name               |
    | -------------------------------- | -------------------------------- |
    |  `AWS_REGION` | `ap-northeast-1` |
    |  `IAM_ROLE` | `github_actions_iam_role` |
    |  `MIGRATION_BATCH_JOB_DEFINITION_NAME` | `migration_job_definition_name` |
    |  `MIGRATION_BATCH_JOB_QUEUE_NAME` | `migration_job_queue_name` |
    |  `MIGRATION_ECR_REPOSITORY_NAME` | `migration_ecr_name` |
    |  `USER_FRONT_APPRUNNER_ARN` | `user_front_apprunner_arn` |
    |  `USER_FRONT_ECR_REPOSITORY_NAME` | `user_front_ecr_name` |


GitHub上の設定値の画面

<img width="2516" height="3122" alt="github-setting-environment-variables.png" src="https://github.com/campbel2525/sample-projects/blob/main/002_nextjs_project/docs/images/github-setting-environment-variables.png" />



3.  **アプリケーションの環境変数の設定**

`apps/user_front/.env.example`、`apps/migration/.env.example`を参考に、アプリケーションで必要な環境変数をAWS Systems Manager (SSM) のパラメータストアに設定してください。


4.  **デプロイの実行**

`stg`ブランチに変更をプッシュすると、GitHub Actionsのワークフローが実行され、ステージング環境に自動でデプロイされます。
