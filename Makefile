SHELL:=/bin/bash
repo_name=functions-2152
image_name=functions
account=343221145296
region=sa-east-1

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

.PHONY: destroy
destroy:
	docker run \
		--env-file ${PWD}/env/credentials.env \
		--interactive \
		--tty \
		--volume ${PWD}/aws:/aws \
		hashicorp/terraform:1.0.11 -chdir=${TF_PATH} destroy

.PHONY: lambda-release
lambda-release:
	docker build functions --tag functions
	aws ecr get-login-password --region ${region} \
		| docker login \
			--username AWS \
			--password-stdin \
			${account}.dkr.ecr.${region}.amazonaws.com
	docker tag ${image_name}:latest ${account}.dkr.ecr.${region}.amazonaws.com/${repo_name}:latest
	docker push ${account}.dkr.ecr.${region}.amazonaws.com/${repo_name}:latest
	aws lambda update-function-code \
		--function-name landing_to_sqs-2152 \
		--image-uri ${account}.dkr.ecr.${region}.amazonaws.com/${repo_name}:latest
