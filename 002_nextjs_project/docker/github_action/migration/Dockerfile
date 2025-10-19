# マイグレーション専用のDockerfile（本番環境用）
FROM public.ecr.aws/docker/library/node:22-bullseye-slim

WORKDIR /app

# 必要最小限のパッケージのみインストール
RUN apt-get update && apt-get install -y \
    openssl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# モノレポ構造をそのまま保持
COPY package.json package-lock.json ./
COPY packages/ ./packages/
COPY apps/migration ./apps/migration/
COPY tsconfig.json ./

# 依存関係をインストール（migrationワークスペースのみ）
RUN npm install -w migration

# Prismaクライアントを生成
RUN npx prisma generate --schema=./packages/db/prisma/schema.prisma

# 不要なキャッシュを削除してイメージサイズを最小化
RUN npm cache clean --force

# 環境変数を設定
ENV NODE_ENV=production
ENV NODE_OPTIONS="--max-old-space-size=1024"

# 非rootユーザーを作成してセキュリティを向上
RUN groupadd -r appuser && useradd -r -g appuser appuser
RUN chown -R appuser:appuser /app
USER appuser

# ヘルスチェック用のスクリプトを追加
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD node -e "console.log('Migration container is healthy')" || exit 1
