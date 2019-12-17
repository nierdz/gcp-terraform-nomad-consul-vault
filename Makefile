MAIN_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
VIRTUALENV_DIR := $(MAIN_DIR)/venv
PATH := $(PATH):$(HOME)/.local/bin
SHELL := /usr/bin/env bash
TAGS ?=

help: ## Print this help
	@grep -E '^[a-zA-Z1-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN { FS = ":.*?## " }; { printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 }'

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

run-ansible: ## Launch ansible-playbook during a packer run
	$(info --> Launch ansible-playbook during a packer run)
	@( \
		source $(VIRTUALENV_DIR)/bin/activate; \
		ansible-playbook -t $(TAGS) playbook.yml; \
	)

run-packer: ## Build packer images
	$(info --> Build packer images)
	@( \
		packer build -var "image_name=consul-vault-image" -on-error=abort packer/consul-vault-packer.json; \
	)

run-terraform: ## Run terraform init and apply
	$(info --> Run terraform init and apply)
	@( \
		pushd terraform; \
		terraform init; \
		terraform apply -auto-approve; \
	)
