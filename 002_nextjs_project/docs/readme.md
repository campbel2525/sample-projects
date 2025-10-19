# コマンドメモ

docker/github_action/migration/Dockerfileをビルドするコマンド
```
docker build -t my-migration-image:latest -f ./docker/github_action/migration/Dockerfile .
```

立ち上げる
```
docker run -d -p 8080:80 --name my-container test:latest
```
