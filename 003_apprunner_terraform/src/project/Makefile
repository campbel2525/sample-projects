# terraformのdocker内で実行すること

help: ## ヘルプを表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

fmt: ## 再起的にfmt
	terraform fmt --recursive

reset:
	find . -type d -name ".terraform" -exec rm -rf {} +
	find . -type f -name ".terraform.lock.hcl" -exec rm -f {} +

# ---------------------------------------------
# ステージング環境
# ---------------------------------------------
stg-init:
	./stg-init.sh

stg-apply: ## apply
	make stg-init
	cd network && terraform apply -auto-approve -var-file=../terraform.stg.tfvars
	cd rds1 && terraform apply -auto-approve -var-file=../terraform.stg.tfvars
	cd banstion && terraform apply -auto-approve -var-file=../terraform.stg.tfvars
	cd apps && terraform apply -auto-approve -target=aws_ecr_repository.user_front_ecr -var-file=../terraform.stg.tfvars
	cd apps && ./push_initial_image.sh aws-stg ap-northeast-1 user-front-repo
	cd apps && terraform apply -auto-approve -var-file=../terraform.stg.tfvars

stg-destroy: ## destroy
	make stg-init
	cd apps && terraform destroy -auto-approve -var-file=../terraform.stg.tfvars
	cd banstion && terraform destroy -auto-approve -var-file=../terraform.stg.tfvars
	cd rds1 && terraform destroy -auto-approve -var-file=../terraform.stg.tfvars
	cd network && terraform destroy -auto-approve -var-file=../terraform.stg.tfvars

# ---------------------------------------------
# 本番環境
# ---------------------------------------------
# prod-init:
# 	./prod-init.sh
# prod-apply: ## apply
# 	make prod-init
# 	cd network && terraform apply -auto-approve -var-file=../terraform.prod.tfvars
# 	cd rds1 && terraform apply -auto-approve -var-file=../terraform.prod.tfvars
# 	cd apps && terraform apply -auto-approve -target=module.user_front_apprunner.aws_ecr_repository.app -var-file=../terraform.prod.tfvars
# 	cd apps && ./push_initial_image.sh aws-prod ap-northeast-1 user-front-repo
# 	cd apps && terraform apply -auto-approve -var-file=../terraform.prod.tfvars

# prod-destroy: ## destroy
# 	make prod-init
# 	cd apps && ./push_initial_image.sh aws-prod ap-northeast-1 user-front-repo
# 	cd rds1 && terraform destroy -auto-approve -var-file=../terraform.prod.tfvars
# 	cd network && terraform destroy -auto-approve -var-file=../terraform.prod.tfvars
