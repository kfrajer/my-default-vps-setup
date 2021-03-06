SHELL := /bin/bash

.PHONY: help

.DEFAULT_GOAL := help

help:
	@echo "Please use 'make <target>' where <target> is one of"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z\._-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

run: ## Run ansible-playbook to specified ips seperated by spaces
	ansible-galaxy install -r requirements.yml
	echo "$(ips)" | tr " " "\n" > inventories/.temp
	ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventories/.temp site.yml --vault-password-file ../.vault-password -u root --tags setup_users
	rm -v inventories/.temp