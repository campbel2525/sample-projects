export PROJECT_NAME=chatbot-ai-agent
pn = chatbot-ai-agent
pf := "./docker/local/docker-compose.yml"

init: ## 開発作成
	make destroy
	docker compose -f $(pf) -p $(pn) build --no-cache
	docker compose -f $(pf) -p $(pn) down --volumes
	docker compose -f $(pf) -p $(pn) up -d
	docker compose -f $(pf) -p $(pn) exec -it ai-agent pipenv install --dev
	docker compose -f $(pf) -p $(pn) exec -it tuning-ai-agent pipenv install --dev


# cp-env: ## .envファイルのコピー
# 	cp apps/ai_agent/.env.example.example apps/ai_agent/.env
# 	cp apps/tuning_ai_agent/.env.example apps/tuning_ai_agent/.env

up: ## 開発立ち上げ
	docker compose -f $(pf) -p $(pn) up -d

down: ## 開発down
	docker compose -f $(pf) -p $(pn) down

ai-agent-shell: ## dockerのshellに入る
	docker compose -f $(pf) -p $(pn) exec ai-agent bash

tuning-ai-agent-shell: ## dockerのshellに入る
	docker compose -f $(pf) -p $(pn) exec tuning-ai-agent bash

check: ## コードのフォーマット
# ai-agent
	docker compose -f $(pf) -p $(pn) exec -it ai-agent pipenv run isort .
	docker compose -f $(pf) -p $(pn) exec -it ai-agent pipenv run black .
	docker compose -f $(pf) -p $(pn) exec -it ai-agent pipenv run flake8 .
	docker compose -f $(pf) -p $(pn) exec -it ai-agent pipenv run mypy .
# tuning-ai-agent
	docker compose -f $(pf) -p $(pn) exec -it tuning-ai-agent pipenv run isort .
	docker compose -f $(pf) -p $(pn) exec -it tuning-ai-agent pipenv run black .
	docker compose -f $(pf) -p $(pn) exec -it tuning-ai-agent pipenv run flake8 .
	docker compose -f $(pf) -p $(pn) exec -it tuning-ai-agent pipenv run mypy .

ai-agent-run:
	docker compose -f $(pf) -p $(pn) exec -it ai-agent pipenv run uvicorn run_fastapi:app --reload --host 0.0.0.0 --port 8000

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
