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

restart: ## 開発再起動
	make down
	make up

mcp-shell: ## dockerのshellに入る
	docker compose -p $(pn) exec mcp bash

langflow-shell: ## dockerのshellに入る
	docker compose -p $(pn) exec langflow bash

check: ## コードのフォーマット
	docker compose -p $(pn) exec -it mcp pipenv run isort .
	docker compose -p $(pn) exec -it mcp pipenv run black .
	docker compose -p $(pn) exec -it mcp pipenv run flake8 .
	docker compose -p $(pn) exec -it mcp pipenv run mypy .

install:
	docker compose -p $(pn) exec -it mcp pipenv install --dev


destroy: ## 環境削除
	make down
	docker network ls -qf name=$(pn) | xargs docker network rm
	docker container ls -a -qf name=$(pn) | xargs docker container rm
	docker volume ls -qf name=$(pn) | xargs docker volume rm

push:
	git add .
	git commit -m "Commit at $$(date +'%Y-%m-%d %H:%M:%S')"
	git push origin head

mcp-run:
	docker compose -p $(pn) exec -it mcp pipenv run python main.py
