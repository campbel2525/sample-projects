# 使用するNode.jsのバージョンを指定
FROM public.ecr.aws/docker/library/node:22-bullseye

# インストール
RUN apt-get update && apt-get install -y --no-install-recommends \
    vim-tiny \
    && rm -rf /var/lib/apt/lists/*

# 環境変数
ENV NODE_ENV=development

# アプリケーションのディレクトリを設定
WORKDIR /project

# # ルートの package.json をコピー
# COPY package*.json ./

# # 依存関係をインストール
# RUN npm install --include=dev
