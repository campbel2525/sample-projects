# Usage

## Get information about the currently executing account

```
module "current_account" {
  source = "../../modules/get_aws_account"
}
```

## Get information about another account

```
module "aws_network_account" {
  source = "../../modules/account"
  providers = {
    aws = aws.aws_network
  }
}
```

