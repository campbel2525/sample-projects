# 補足

Next.js のプロジェクト[sample-nextjs-project](https://github.com/campbel2525/sample-projects/tree/main/002_nextjs_project)と合わせて使用すると Next.js のアプリケーション、インフラ周りが完了します

# AWS App Runner on Terraform

Next.js で構築されたアプリケーションを AWS App Runner で公開するための Terraform プロジェクトです。

## インフラ構成図

<img width="1564" height="1296" alt="image" src="https://github.com/user-attachments/assets/fc27b099-8614-4388-adf8-a09bb0cbece0" />


## 必要要件

- [Docker](https://www.docker.com/)
- [make](https://www.gnu.org/software/make/)

## セットアップ

1.  **AWS SSO の設定**:
    AWS アカウントで SSO を有効化してください。

2.  **S3 バケットの作成**:
    Terraform の State ファイルを保存するための S3 バケットを AWS 上に作成します。

3.  **AWS 認証情報の設定**:
    `credentials/aws/config.example` を参考に `credentials/aws/config` を作成します。

4.  **初期化**:
    `make init` を実行して、Docker イメージのビルドなどを行います。

## デプロイ手順 (ステージング環境の例)

1.  **バックエンド設定ファイルの作成**:
    `src/project/backend-config.stg.hcl.example` をコピーして `src/project/backend-config.stg.hcl` を作成します。`bucket`には、セットアップ手順 2 で作成した S3 バケット名を指定してください。

2.  **変数ファイルの作成**:
    `src/project/terraform.stg.tfvars.example` をコピーして `src/project/terraform.stg.tfvars` を作成し、環境に合わせて変数を設定します。

3.  **Docker コンテナに入る**:
    `make shell` を実行して、Terraform 実行用のコンテナに入ります。

    ***

    **以下の手順は Docker コンテナ内で実行します。**

4.  **プロジェクトディレクトリへ移動**:

    ```sh
    cd /project/project
    ```

5.  **AWS へログイン**:
    SSO で AWS にログインします。

    ```sh
    sl
    ```

6.  **Terraform の実行**:
    ステージング環境にインフラを構築します。

    ```sh
    make stg-apply
    ```

    インフラを削除する場合は `make stg-destroy` を実行します。

7.  **動作確認**:
    コンソールに出力された App Runner のデフォルトドメインにアクセスし、サンプルページが表示されればデプロイ成功です。
    (この時点では、AWS 提供のサンプルイメージ `public.ecr.aws/aws-containers/hello-app-runner` がデプロイされています)

8.  アプリケーションいなわせてコンソールに出力される値を元に適切に環境変数を設定する

## コマンドリファレンス

### GitHub Actions OIDC 用 Thumbprint 取得

GitHub Actions から OIDC で AWS に接続する場合に必要となる Thumbprint を取得します。

```sh
openssl s_client -connect token.actions.githubusercontent.com:443 -showcerts \
 </dev/null 2>/dev/null \
 | openssl x509 -noout -fingerprint -sha1 \
 | sed 's/://g' | sed 's/SHA1 Fingerprint=//'
```

_注意: 環境変数などに設定する際は、結果を小文字に変換してください。_

## 補足事項

### App Runner の初回デプロイについて

`terraform apply` で App Runner サービスを新規作成すると、必ずデプロイが実行されます。このとき、デプロイするコンテナイメージが ECR に存在しないとエラーになります。

そのため、インフラの構築は以下のステップで行う必要があります。

1.  **ECR リポジトリの作成**:
    まず ECR リポジトリのみを作成します。

    ```sh
    # (例)
    terraform apply -auto-approve -target=module.user_front_apprunner.aws_ecr_repository.app -var-file=../terraform.stg.tfvars
    ```

2.  **サンプルイメージの Push**:
    作成した ECR リポジトリに、AWS 提供のサンプルイメージを Push します。
    `push_initial_image.sh` に具体的な処理が記述されています。

    ```sh
    # (例)
    ./push_initial_image.sh aws-stg ap-northeast-1 user-front-repo
    ```

3.  **App Runner サービスの作成**:
    ECR にイメージが Push された状態で、App Runner を含むすべてのリソースを apply します。
    ```sh
    # (例)
    terraform apply -auto-approve -var-file=../terraform.stg.tfvars
    ```

`src/project/Makefile` の `stg-apply` ターゲットでは、これらの手順が自動的に実行されるようになっています。

# コマンドメモ

stg 環境の例です

## terraform

```
terraform init -backend-config=../backend-config.hcl
```

## AWS CLI

## EC2 一覧

```
aws --profile aws-stg ec2 describe-instances
```

## RDS 一覧

```
aws --profile aws-stg rds describe-db-instances
```
