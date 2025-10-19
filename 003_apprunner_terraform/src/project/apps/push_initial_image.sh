#!/bin/bash

# --- 引数のチェック ---
if [ "$#" -ne 3 ]; then
    echo "エラー: 3つの引数が必要です。"
    echo "使い方: $0 <AWSプロファイル名> <AWSリージョン> <ECRリポジトリ名>"
    exit 1
fi

# --- ★ここから追加★ Dockerデーモンの起動と停止予約 ---
# スクリプトが終了する際に（成功・失敗問わず）必ずdockerdを停止する
# trap "echo 'Stopping Docker daemon...'; pkill dockerd" EXIT

# Dockerデーモンをバックグラウンドで起動
echo "Starting Docker daemon..."
dockerd > /dev/null 2>&1 &

# Dockerデーモンが起動するまで待機
while(!docker info > /dev/null 2>&1); do
    echo "Waiting for the Docker daemon to be ready..."
    sleep 1
done
echo "Docker daemon is ready."
# --- ★ここまで追加★ ---


# --- 引数を変数に設定 ---
AWS_PROFILE="$1"
AWS_REGION="$2"
ECR_REPOSITORY_NAME="$3"
DOCKER_IMAGE="public.ecr.aws/aws-containers/hello-app-runner:latest"

echo "--- Script Settings ---"
echo "AWS Profile: $AWS_PROFILE"
echo "AWS Region: $AWS_REGION"
echo "ECR Repository: $ECR_REPOSITORY_NAME"
echo "-----------------------"

# --- コマンド実行 (以下は変更不要) ---
# ... (AWSアカウントID取得からdocker pushまでの処理は同じ) ...
echo "Getting AWS Account ID..."
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text --profile "$AWS_PROFILE")
if [ -z "$AWS_ACCOUNT_ID" ]; then
    echo "Failed to get AWS Account ID. Please check your SSO session and profile name."
    exit 1
fi
echo "AWS Account ID: $AWS_ACCOUNT_ID"

ECR_REPO_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY_NAME}"
echo "ECR Repository URL: $ECR_REPO_URL"

echo "Pulling hello-apprunner image..."
docker pull $DOCKER_IMAGE

echo "Logging in to Amazon ECR..."
aws ecr get-login-password --region "$AWS_REGION" --profile "$AWS_PROFILE" | docker login --username AWS --password-stdin "$ECR_REPO_URL"

echo "Tagging image for your repository..."
# Create both initial and latest tags
docker tag $DOCKER_IMAGE "$ECR_REPO_URL:initial-sample-image"
docker tag $DOCKER_IMAGE "$ECR_REPO_URL:latest"

echo "Pushing images to your ECR repository..."
# Push both tags
docker push "$ECR_REPO_URL:initial-sample-image"
docker push "$ECR_REPO_URL:latest"

echo "🔍 Pushed tags: initial, latest"
echo "✅ Push completed successfully!"
