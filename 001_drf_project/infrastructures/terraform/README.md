# Terraform の環境構築

下記の手順は環境を 1 から作成する手順です

## 1 環境設定

1
下記の設定を行う

- `credentials/aws/config.example`を参考にして`credentials/aws/config`を作成。(SSO でのログインを前提としている)
- `infrastructures/terraform/src/aws/project/backend-config.hcl.example`を参考に`infrastructures/terraform/src/aws/project/backend-config.prod.hcl`を作成
- `infrastructures/terraform/src/aws/project/terraform.tfvars.example`を参考に`infrastructures/terraform/src/aws/project/terraform.prod.tfvars`を作成

## 2 Route 53 の設定

### 1

```
make shell
make init
cd /project/aws/project/route53
terraform init -backend-config=../backend-config.hcl
terraform apply
```

### 2 DNS の設定

参考: Udemy

お名前.com でドメイン(example.com)を取得したと想定します

stg は

- stg-example.com
  prod は
- example.com

のようなドメインを想定しているため、このドメインの設定は stg と prod で共通で 1 回行うことになります

下記は手順です

1 ACM や Route 53 の設定(ネームサーバー)

terraform/common/route53/terraform.tfvars.example

を参考に

terraform/common/route53/terraform.tfvars

を作成する

その後に下記のコマンドを実行する

```
cd terraform/common/route53
terraform init -migrate-state && terraform apply -auto-approve
```

2 お名前.com の DNS の設定

AWS のマネコンを開き、Route 53 のリソースにアクセスし、作成されたホストゾーンを開く

作成された タイプが「NS」 の「値/トラフィックのルーティング先」の値を値をお名前.com のネームサーバーに設定を行う(最後の「.」は外す)

3 ACM の CNAME をお名前.com に設定

手順 2 の画面と同じ

ACM を開く(東京、バージニアリージョンのどっちでも OK)

お名前.com の「DNS 設定/転送設定」のリンク -> DNS レコード設定を利用する

その CNAME をお名前.com の DNS レコードに追加する(最後の「.」は外す)

設定項目

- 「お名前.com のホスト名」には「AWS のレコード名」
- 「お名前.com の VALUE」には「AWS の値/トラフィックのルーティング先」
- 「お名前.com の TYPE」は CNAME

ネームサーバーの変更確認コマンド

```
nslookup -type=ns example.com
```

ここまで行ったら、一旦コンソールを終了して OK

時間が経つと

保留中の検証 -> 成功

ステータスが変わる(はず)

## 3 本番環境の設定

### 1. 環境ファイルの設定

- `infrastructures/terraform/src/aws/project/terraform.tfvars.example`を参考に`infrastructures/terraform/src/aws/project/backend-config.prod.hcl`を作成
- 「GitHub の ghp の設定方法」を参考にしてキーを作成し`infrastructures/terraform/src/aws/project/terraform.prod.tfvars`にセットする

### 2

リソースの作成

```
make shell
cd /project/aws/
make prod-apply
```

### 3

下記のことを行う

- コンソールを開いて SSM にプロジェクトの.env を登録する
- CodePipeline -> 編集 -> 編集: Source のステージの編集 -> 保留中の接続を更新 -> 接続を更新 -> 保存
  - 一回ではうまくいかないので何回か繰り返す
  - 「GitHub と連携する」を参考にして連携を行う

## GitHub と連携する

GitHub を organizations ではなく、直接 CodePipeline があるアカウントで開く

CodePipeline -> 編集 -> 編集: Source のステージの編集 -> GitHub に接続する -> タブを閉じる -> 保留中の接続を更新 -> 接続を更新 -> 保存

上記に加えてステージの編集から「GitHub に接続する」を選択して設定する必要あり

## GitHub の ghp の設定方法

Fine-grained token の設定が必要

Fine-grained token の設定場所
profile settings > Developer Settings > Personal access tokens > tokens (classic)

下記の項目を設定する

- 適切な名前と
- 適切なリポジトリと
- 適切な権限
  - Administration: Read and write
  - Webhooks: Read and write

## 今後の課題

1.  下記の内容を要調査する

- IAM の権限の絞り込み
- ロールの権限の絞り込み
- GitHub 連携をもっといい感じにできる？

2. VPC エンドポイントの再考察
   現状設定している VPC エンドポイントは ecr.dkr, ecr.api, s3 の 3 つのみです。 他にも logs, secretsmanager, ssm, ssmmessages の VPC エンドポイントもあるようです
   よく要検討すること
   参考 url
   https://dev.classmethod.jp/articles/vpc-endpoints-for-ecs-2022/
   https://qiita.com/ldr/items/7c8bc08baca1945fdb50

3. 現状は prod しかないが stg 環境も作る。マルチ環境は Terraform でどう作るか考える
   参考 url
   https://qiita.com/poly_soft/items/c71bb763035b2047d2db

4. アプリから RDS への接続はパスワードではなくロールベースに変更する

5. CI/CD を実行した時に NAT を通ってイメージを作成している可能性がある。

# コマンドメモ

## Terraform

```
terraform init -backend-config=../backend-config.hcl
```

## AWS CLI

## EC2 一覧

```
aws --profile aws-prod ec2 describe-instances
```

## RDS 一覧

```
aws --profile aws-prod rds describe-db-instances
```

## 踏み台サーバー - shell

```
aws ssm start-session \
--target i-xxx \
--document-name SSM-SessionManagerRunShell \
--profile aws-prod
```

## 踏み台サーバー - ポートフォワード

```
aws ssm start-session \
--target i-xxx \
--document-name AWS-StartPortForwardingSessionToRemoteHost \
--parameters '{"host":["<rdsのエンドポイント>"],"portNumber":["3306"],"localPortNumber":["13306"]}' \
--profile aws-prod
```

## ECS に入る

```
aws ecs execute-command \
  --cluster admin-api-ecs-cluster \
  --task 229dad544789425fa98e5ef3de1474c0 \
  --container admin-api-app \
  --command "/bin/sh" \
  --interactive \
  --profile aws-prod
```
