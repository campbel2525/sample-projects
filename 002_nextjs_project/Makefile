include docker/local/.env
pf := "./docker/local/docker-compose.yml"
pn := $(PROJECT_NAME)

help: ## ヘルプを表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

cp-env: ## envのコピー
	cp apps/user_front/.env.example apps/user_front/.env
	cp docker/.env.example docker/.env

init: ## 開発環境構築(ビルド)
# 開発環境の削除
	make destroy
# キャッシュ、ログ、ライブラリの削除
# make c
# ビルド
	docker compose -f $(pf) -p $(pn) build --no-cache
	docker compose -f $(pf) -p $(pn) down --volumes
	docker compose -f $(pf) -p $(pn) up -d
	./docker/local/wait-for-db.sh
	docker compose -f $(pf) -p $(pn) exec -T db mysql -psecret < docker/local/setup.dev.sql
# ライブラリのインストール
	make install
# DBリセット
	make reset

up: ## 開発環境up
	docker compose -f $(pf) -p $(pn) up -d
	make install

down: ## 開発環境down
	docker compose -f $(pf) -p $(pn) down

destroy: ## 開発環境削除
	make down
	if [ -n "$(docker network ls -qf name=$(pn))" ]; then \
		docker network ls -qf name=$(pn) | xargs docker network rm; \
	fi
	if [ -n "$(docker container ls -a -qf name=$(pn))" ]; then \
		docker container ls -a -qf name=$(pn) | xargs docker container rm; \
	fi
	if [ -n "$(docker volume ls -qf name=$(pn))" ]; then \
		docker volume ls -qf name=$(pn) | xargs docker volume rm; \
	fi

reset: ## DBのリセット
	docker compose -f $(pf) -p $(pn) exec -it migration npx prisma migrate reset -f
	docker compose -f $(pf) -p $(pn) exec -it migration npx prisma migrate dev
	docker compose -f $(pf) -p $(pn) exec -it migration npm run seed -w migration

install: ## インストール
	docker compose -f $(pf) -p $(pn) exec -it migration npm install
	docker compose -f $(pf) -p $(pn) exec -it migration npx prisma generate
	docker compose -f $(pf) -p $(pn) exec -it user_front npm install
	docker compose -f $(pf) -p $(pn) exec -it user_front npx prisma generate

user-front-shell: ## shellに入る
	docker compose -f $(pf) -p $(pn) exec -it user_front bash

migration-shell: ## shellに入る
	docker compose -f $(pf) -p $(pn) exec -it migration bash

db-shell: ## shellに入る
	docker compose -f $(pf) -p $(pn) exec -it db bash

check: ## コードフォーマット
# user_front
	docker compose -f $(pf) -p $(pn) exec -it migration npx prettier . --write
	docker compose -f $(pf) -p $(pn) exec -it migration npx eslint . --fix
	docker compose -f $(pf) -p $(pn) exec -it migration npx tsc --noEmit
# user_front
	docker compose -f $(pf) -p $(pn) exec -it user_front npx prettier . --write
	docker compose -f $(pf) -p $(pn) exec -it user_front npm run lint -- --fix
	docker compose -f $(pf) -p $(pn) exec -it user_front npx tsc --noEmit

user-front-run: ## サーバー起動
	docker compose -f $(pf) -p $(pn) exec -it user_front npm run dev -w user_front

# user_front-build-run: ## サーバー起動
# 	docker compose -f $(pf) -p $(pn) exec -it user_front npm run build
# 	docker compose -f $(pf) -p $(pn) exec -it user_front sh -c "HOST=0.0.0.0 PORT=3001 node build"

# c: ## キャッシュ、ログ、ライブラリの削除
# # キャッシュの削除
# 	find . -type d -name ".next" -exec rm -rf {} +
# 	find . -type f -name "next-env.d.ts" -exec rm -f {} +

# # ログの削除
# 	find . -type f -name "fastapi.log" -exec rm -f {} +
# 	find . -type f -name "django.log" -exec rm -f {} +

# # ライブラリの削除
# 	make lib-c

# lib-c: ## ライブラリの削除
# 	find . -type d -name ".venv" -exec rm -rf {} +
# 	find . -type d -name "node_modules" -exec rm -rf {} +

push: ## push
# make format
# git switch main
# git pull origin main
	git add .
	git commit -m "Commit at $$(date +'%Y-%m-%d %H:%M:%S')"
	git push origin head
# git push origin main:prod
	git push origin main:stg


# github-init:
# # ビルド
# 	docker compose -f $(pf) -p $(pn) build --no-cache
# 	docker compose -f $(pf) -p $(pn) down --volumes
# 	docker compose -f $(pf) -p $(pn) up -d
# 	./docker/local/wait-for-db.sh
# 	docker compose -f $(pf) -p $(pn) exec -T db mysql -psecret < docker/local/setup.dev.sql
# # ライブラリのインストール
# 	make install
# # DBリセット
# 	make reset

# github-check:
# # admin-api
# 	docker compose -f $(pf) -p $(pn) exec -it admin-api bash -c "pipenv run isort . --check-only"
# 	docker compose -f $(pf) -p $(pn) exec -it admin-api bash -c "pipenv run black . --check"
# 	docker compose -f $(pf) -p $(pn) exec -it admin-api bash -c "pipenv run flake8 ."
# 	docker compose -f $(pf) -p $(pn) exec -it admin-api bash -c "pipenv run mypy ."
# # user-api
# 	docker compose -f $(pf) -p $(pn) exec -it user-api bash -c "pipenv run isort . --check-only"
# 	docker compose -f $(pf) -p $(pn) exec -it user-api bash -c "pipenv run black . --check"
# 	docker compose -f $(pf) -p $(pn) exec -it user-api bash -c "pipenv run flake8 ."
# 	docker compose -f $(pf) -p $(pn) exec -it user-api bash -c "pipenv run mypy ."
# # admin-front
# 	docker compose -f $(pf) -p $(pn) exec -it admin-front bash -c "npx prettier . --check"
# 	docker compose -f $(pf) -p $(pn) exec -it admin-front bash -c "npx eslint ."
# 	docker compose -f $(pf) -p $(pn) exec -it admin-front npx tsc --noEmit
# # user_front
# 	docker compose -f $(pf) -p $(pn) exec -it user_front bash -c "npx prettier . --check"
# 	docker compose -f $(pf) -p $(pn) exec -it user_front bash -c "npx eslint ."
# 	docker compose -f $(pf) -p $(pn) exec -it user_front npx tsc --noEmit

reset-commit: ## mainブランチのコミット履歴を1つにする 使用は控える
	git checkout --orphan new-branch-name
	git add .
	git branch -D main
	git branch -m main
	git commit -m "first commit"
	git push origin -f main
