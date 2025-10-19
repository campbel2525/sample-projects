# 使用方法

## 実行しているアカウントの情報を取得する場合

```
module "current_account" {
  source = "../../modules/get_aws_account"
}
```

## 他のアカウント情報を取得したい場合

```
module "aws_network_account" {
  source = "../../modules/account"
  providers = {
    aws = aws.aws_network
  }
}
```
