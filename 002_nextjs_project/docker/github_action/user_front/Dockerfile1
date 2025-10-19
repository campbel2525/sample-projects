# =================================================================
# --- Build Stage ---
# アプリケーションのビルドと依存関係の準備を行います
# =================================================================
FROM public.ecr.aws/docker/library/node:22-bullseye AS builder

WORKDIR /app

# 1. 依存関係の解決に必要なマニフェストファイルを先にコピーします
#    これにより、ソースコードの変更時に不要な `npm ci` の再実行を防ぎます
COPY package.json package-lock.json* ./
COPY apps/user_front/package.json ./apps/user_front/
COPY packages/db/package.json ./packages/db/

# 2. すべての依存関係をインストールします
#    `npm ci` を使うことで、ロックファイルに基づいた再現性の高いインストールを実現します
RUN npm ci

# 3. ビルドに必要なソースコードのみを明示的にコピーします
#    `COPY . .` を避けることで、不要なファイルがイメージに含まれるのを防ぎます
COPY apps/user_front/ ./apps/user_front/
COPY packages/db/ ./packages/db/
COPY packages/tsconfig/ ./packages/tsconfig/

# 4. Prisma Clientを生成します
#    スキーマファイルの場所を明示的に指定することで、どこからでも実行可能にします
RUN npx prisma generate --schema=./packages/db/prisma/schema.prisma

# 5. user_front アプリケーションをビルドします
RUN npm run build -w user_front


# =================================================================
# --- Production Stage ---
# ビルドされたアプリケーションを実行するための軽量なイメージを作成します
# =================================================================
FROM public.ecr.aws/docker/library/node:22-bullseye-slim AS runner

# 1. 非rootユーザーを作成し、セキュリティを向上させます
RUN addgroup --system --gid 1001 nodejs \
    && adduser --system --uid 1001 --ingroup nodejs nextjs

WORKDIR /app

# 2. 本番環境用の環境変数を設定します
ENV NODE_ENV=production \
    NEXT_TELEMETRY_DISABLED=1 \
    HOSTNAME="0.0.0.0" \
    PORT=3000

# 3. 実行に必要な `package.json` をコピーします
#    `npm start` スクリプトを実行するために必要です
COPY package.json ./
COPY apps/user_front/package.json ./apps/user_front/

# --- ここからが重要な変更点です ---

# 4. ビルドステージから必要なファイルをコピーします
#    --chown フラグで、ファイルの所有者を `nextjs` ユーザーに設定します

#    a) 依存関係（Prisma Clientと実行エンジンを含む）を丸ごとコピーします
#       プロダクションステージで `npm install` を再実行する必要はありません
COPY --from=builder --chown=nextjs:nodejs /app/node_modules ./node_modules

#    b) Next.jsのビルド成果物をコピーします
COPY --from=builder --chown=nextjs:nodejs /app/apps/user_front/.next ./apps/user_front/.next

#    c) publicディレクトリ（画像などの静的ファイル）をコピーします
COPY --from=builder --chown=nextjs:nodejs /app/apps/user_front/public ./apps/user_front/public

#    d) Prismaが実行時に参照するスキーマファイルをコピーします
COPY --from=builder --chown=nextjs:nodejs /app/packages/db/prisma/schema.prisma ./packages/db/prisma/schema.prisma

#    e) Next.jsの設定ファイルをコピーします
COPY --from=builder --chown=nextjs:nodejs /app/apps/user_front/next.config.js ./apps/user_front/next.config.js

# --- 変更点はここまでです ---

# 5. ユーザーを `nextjs` に切り替えます
USER nextjs

# 6. ポートを開放します
EXPOSE 3000

# 7. アプリケーションを起動します
#    -w フラグで `user_front` ワークスペースの `start` スクリプトを指定します
CMD ["npm", "start", "-w", "user_front"]
