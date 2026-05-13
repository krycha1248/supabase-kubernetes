.PHONY: \
	init init-ci \
	plan plan-ci \
	apply apply-ci \
	destroy destroy-ci \
	config \
	all local ci

#
# helpers
#

SHELL := /bin/bash

TF_LOCAL := . ./variables.sh && terraform
TF_CI := terraform

#
# LOCAL
#

init:
	@$(TF_LOCAL) init -upgrade

plan:
	@$(TF_LOCAL) plan

apply:
	@$(TF_LOCAL) apply -auto-approve

destroy:
	@$(TF_LOCAL) destroy

config:
	@mkdir -p ~/.kube && $(TF_LOCAL) output -raw kubernetes_config > ~/.kube/config

local: init apply config

#
# CI/CD
#

init-ci:
	@$(TF_CI) init -upgrade

plan-ci:
	@$(TF_CI) plan

apply-ci:
	@$(TF_CI) apply -auto-approve

destroy-ci:
	@$(TF_CI) destroy -auto-approve -input=false

ci: init-ci apply-ci