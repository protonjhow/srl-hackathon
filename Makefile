# CI/CD tasks

.DEFAULT_GOAL := help

.PHONY: help deploy-hackathon destroy-hackathon run-tests

TESTS := $(shell find ./tests/ -name '*.sh')

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

deploy-clab-ci: ## Deploy ACL test topology
	sudo clab deploy -t hackathon-topo.yml --reconfigure
	cp clab-hackathon/ansible-inventory.yml hackathon-inventory.yml
	poetry run python3 baseline_acl_test_topo.py
	sleep 10 && ./add-saved-objects.sh

destroy-clab-ci: ## Destroy ACL test topology
	sudo clab destroy -t hackathon-topo.yml --cleanup
	rm hackathon-inventory.yml

run-tests: $(TESTS) ## Run all tests under tests folder 
	#bash -c $<
	sleep 1	
