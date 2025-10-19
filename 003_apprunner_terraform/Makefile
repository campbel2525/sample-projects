pn = 'sample-apprunner-terraform'

init: ## 環境構築(ビルド)
	make destroy
	docker compose -p $(pn) build --no-cache
	docker compose -p $(pn) down --volumes
	docker compose -p $(pn) up -d

up: ## 環境up
	docker compose -p $(pn) up -d

down: ## 環境down
	docker compose -p $(pn) down

destroy: ## 環境削除
	make down
	docker network ls -qf name=$(pn) | xargs docker network rm
	docker container ls -a -qf name=$(pn) | xargs docker container rm
	docker volume ls -qf name=$(pn) | xargs docker volume rm

shell: ## shellに入る
	docker compose -p $(pn) exec -it terraform bash

tree:
	tree -a -I .git -I .DS_Store -I registry.terraform.io

push:
	git add .
	git commit -m "Commit at $$(date +'%Y-%m-%d %H:%M:%S')"
	git push origin main

reset-commit: ## mainブランチのコミット履歴を1つにする 使用は控える
	git checkout --orphan new-branch-name
	git add .
	git branch -D main
	git branch -m main
	git commit -m "first commit"
	git push origin -f main
