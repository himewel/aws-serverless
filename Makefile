SHELL:=/bin/bash

.PHONY: apply
apply:
	docker run \
		--env-file ${PWD}/env/credentials.env \
		--interactive \
		--tty \
		--volume ${PWD}/aws:/aws \
		hashicorp/terraform:1.0.11 -chdir=${TF_PATH} apply

.PHONY: plan
plan:
	docker run \
		--env-file ${PWD}/env/credentials.env \
		--interactive \
		--tty \
		--volume ${PWD}/aws:/aws \
		hashicorp/terraform:1.0.11 -chdir=${TF_PATH} plan

.PHONY: init
init:
	docker run \
		--env-file ${PWD}/env/credentials.env \
		--interactive \
		--tty \
		--volume ${PWD}/aws:/aws \
		hashicorp/terraform:1.0.11 -chdir=${TF_PATH} init
