MAIN_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
VIRTUALENV_DIR := $(MAIN_DIR)/venv
PATH := $(PATH):$(HOME)/.local/bin
SHELL := /usr/bin/env bash
TAGS ?=

help: ## Print this help
	@grep -E '^[a-zA-Z1-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN { FS = ":.*?## " }; { printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 }'

tests: ## Run all tests
	$(info --> Run all tests)
	@( \
		source $(VIRTUALENV_DIR)/bin/activate; \
		yamllint -c .yamllint.yml .; \
		pre-commit run --all-files; \
		pushd ansible; \
		ansible-lint playbook.yml; \
		ansible-playbook playbook.yml --syntax-check; \
	)

install: ## Install dependencies
	$(info --> Install dependencies)
	@( \
		sudo apt update; \
		sudo apt install -y \
			git \
			python-apt \
			python-netaddr \
			python-pip \
			python-virtualenv ;\
	)
	@$(MAKE) install-ansible

venv: ## Create python virtualenv if not exists
	[[ -d $(VIRTUALENV_DIR) ]] || virtualenv --system-site-packages $(VIRTUALENV_DIR)

install-ansible: ## Install ansible via pip
	$(info --> Install ansible via `pip`)
	@$(MAKE) venv
	@( \
		source $(VIRTUALENV_DIR)/bin/activate; \
		pip install --upgrade setuptools; \
		pip install -r requirements.txt; \
		ansible-galaxy install -r ansible/requirements.yml -p ansible/vendor/roles ; \
	)

create-key: ## Create a keyring and a key to unseal vault
	$(info --> Create a keyring and a key to unseal vault )
	@( \
		source env.sh; \
		gcloud kms keyrings create tncv-key-ring --location $(TF_VAR_region); \
		gcloud kms keys create vault-key --keyring tncv-key-ring \
		  --purpose=encryption --location $(TF_VAR_region) \
			--rotation-period 86400s \
			--next-rotation-time $(shell date -d "+1 hour" +'%Y-%m-%dT%T'); \
	)

run-ansible: ## Launch ansible-playbook during a packer run
	$(info --> Launch ansible-playbook during a packer run)
	@( \
		source $(VIRTUALENV_DIR)/bin/activate; \
		source ../env.sh; \
		ansible-playbook -t $(TAGS) playbook.yml; \
	)

run-packer: ## Build packer images
	$(info --> Build packer images)
	@( \
		packer build -var "image_name=consul-vault-image" -force -on-error=abort packer/consul-vault-packer.json; \
	)

run-terraform: ## Run terraform init and apply
	$(info --> Run terraform init and apply)
	@( \
		pushd terraform; \
		terraform init -backend-config "bucket=$(TF_VAR_project_name)"; \
		terraform apply -auto-approve; \
	)

destroy-terraform: ## Run terraform destroy
	$(info --> Run terraform destroy)
	@( \
		pushd terraform; \
		terraform destroy -auto-approve; \
	)
