# ベースイメージ
FROM python:3.11-slim-bullseye

WORKDIR /project

# パッケージの更新と、bashを含む必要パッケージのインストール
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    curl unzip vim groff less make jq zip ca-certificates gnupg procps bash # bashを追加

# --- ▼▼▼ Dockerインストールのための追加 ▼▼▼ ---
# Docker公式のGPGキーを追加
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
RUN chmod a+r /etc/apt/keyrings/docker.asc

# Dockerのリポジトリを追加
RUN echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null

# Dockerエンジンをインストール
RUN apt-get update && \
    apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin
# --- ▲▲▲ ここまで ▲▲▲ ---


# AWS CLIのインストール用ディレクトリ作成
RUN mkdir /root/.aws/

# aws-cliのインストール
ARG AWSCLI_VERSION="2.17.12"
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip" -o "/tmp/awscliv2.zip" && \
    unzip -o /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -rf /tmp/aws /tmp/awscliv2.zip

# Session Manager Pluginのインストール
ARG SESSION_MANAGER_PLUGIN_VERSION="1.2.650.0"
RUN curl "https://s3.amazonaws.com/session-manager-downloads/plugin/${SESSION_MANAGER_PLUGIN_VERSION}/ubuntu_64bit/session-manager-plugin.deb" -o "/tmp/session-manager-plugin.deb" && \
    dpkg -i /tmp/session-manager-plugin.deb || apt-get install -f -y && \
    rm /tmp/session-manager-plugin.deb

# Terraformのインストール
ARG TERRAFORM_VERSION="1.8.0"
RUN curl "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o "/tmp/terraform.zip" && \
    unzip /tmp/terraform.zip -d /tmp && \
    mv /tmp/terraform /usr/local/bin/ && \
    rm /tmp/terraform.zip

# tflintのインストール
ARG TFLINT_VERSION="0.52.0"
RUN curl -L "https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip" -o "/tmp/tflint.zip" && \
    unzip /tmp/tflint.zip -d /tmp && \
    mv /tmp/tflint /usr/local/bin/ && \
    rm /tmp/tflint.zip

# エイリアスの設定 (bashを使用するように修正)
RUN echo "alias sl='aws sso login --profile aws-stg'" >> ~/.bashrc
RUN echo "alias ta='terraform apply -auto-approve -var-file=../terraform.stg.tfvars'" >> ~/.bashrc
RUN echo "alias td='terraform destroy -auto-approve -var-file=../terraform.stg.tfvars'" >> ~/.bashrc
RUN echo "alias ti='terraform init -backend-config=../backend-config.stg.hcl -var-file=../terraform.stg.tfvars -reconfigure'" >> ~/.bashrc
