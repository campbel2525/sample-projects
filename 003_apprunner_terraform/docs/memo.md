## 踏み台サーバー - shell

```
aws ssm start-session \
--target i-xxx \
--document-name SSM-SessionManagerRunShell \
--profile aws-stg
```

## 踏み台サーバー - ポートホワード

```
aws ssm start-session \
--target i-xxx \
--document-name AWS-StartPortForwardingSessionToRemoteHost \
--parameters '{"host":["<rdsのエンドポイント>"],"portNumber":["3306"],"localPortNumber":["13306"]}' \
--profile aws-stg
```

## ecs に入る

```
aws ecs execute-command \
  --cluster admin-api-ecs-cluster \
  --task 229dad544789425fa98e5ef3de1474c0 \
  --container admin-api-app \
  --command "/bin/sh" \
  --interactive \
  --profile aws-stg
```
