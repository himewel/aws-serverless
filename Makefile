SHELL:=/bin/bash
REPO=functions-2152
IMAGE=functions
ACCOUNT=343221145296
REGION=sa-east-1

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
	aws ecr get-login-password --region ${REGION} \
		| docker login \
			--username AWS \
			--password-stdin \
			${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com
	docker tag ${IMAGE}:latest ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${REPO}:latest
	docker push ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${REPO}:latest
	aws lambda update-function-code \
		--function-name ${FUNCTION} \
		--image-uri ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${REPO}:latest
