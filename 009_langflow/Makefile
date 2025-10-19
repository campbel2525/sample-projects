pn = '009_langflow'

init: ## 開発作成
	docker compose -p $(pn) build --no-cache
	docker compose -p $(pn) down --volumes
	docker compose -p $(pn) up -d
	make install

up: ## 開発立ち上げ
	docker compose -p $(pn) up -d

down: ## 開発down
	docker compose -p $(pn) down

shell: ## dockerのshellに入る
	docker compose -p $(pn) exec python bash

check: ## コードのフォーマット
	docker compose -p $(pn) exec -it python pipenv run isort .
	docker compose -p $(pn) exec -it python pipenv run black .
	docker compose -p $(pn) exec -it python pipenv run flake8 .
	docker compose -p $(pn) exec -it python pipenv run mypy .

install:
	docker compose -p $(pn) exec -it python pipenv install --dev


destroy: ## 環境削除
	make down
	docker network ls -qf name=$(pn) | xargs docker network rm
	docker container ls -a -qf name=$(pn) | xargs docker container rm
	docker volume ls -qf name=$(pn) | xargs docker volume rm

push:
	git add .
	git commit -m "Commit at $$(date +'%Y-%m-%d %H:%M:%S')"
	git push origin head
