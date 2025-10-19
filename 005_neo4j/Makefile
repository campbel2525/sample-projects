PROJECT_NAME = sample-neo4j
pn = $(PROJECT_NAME)

init: ## 開発作成
	docker compose -p $(pn) build --no-cache
	docker compose -p $(pn) down --volumes
	docker compose -p $(pn) up -d

up: ## 開発立ち上げ
	docker compose -p $(pn) up -d

down: ## 開発down
	docker compose -p $(pn) down

shell: ## dockerのshellに入る
	docker compose -p $(pn) exec app bash


destroy: ## 環境削除
	make down
	docker network ls -qf name=$(pn) | xargs docker network rm
	docker container ls -a -qf name=$(pn) | xargs docker container rm
	docker volume ls -qf name=$(pn) | xargs docker volume rm

push:
	git add .
	git commit -m "Commit at $$(date +'%Y-%m-%d %H:%M:%S')"
	git push origin head


reset-commit: ## mainブランチのコミット履歴を1つにする 使用は控える
	git checkout --orphan new-branch-name
	git add .
	git branch -D main
	git branch -m main
	git commit -m "first commit"
	git push origin -f main
