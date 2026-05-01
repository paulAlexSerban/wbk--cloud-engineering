
INFRA_PROVISIONING_SCRIPTS := ./infrastructure/provisioning/scripts
INFRA_SERVER_TEMPLATING_DOCKER_SCRIPTS := ./infrastructure/server-templating/docker
INFRA_PROVISIONING_TERRAFORM_DIR := ./infrastructure/provisioning/terraform
INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR := ./infrastructure/orchestration/docker

# ----------------------------------------------
# Start localstack services
# ----------------------------------------------
.PHONY: hello-python-lambda-localstack_compose-up \
		hello-python-lambda-localstack_compose-down \
		hello-python-lambda-localstack_compose-down-clean

hello-python-lambda-localstack_compose-up: 
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/hello-python-lambda.locakstack.docker-compose.bash --phase=up --app-name=hello-python-lambda

hello-python-lambda-localstack_compose-down:
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/hello-python-lambda.locakstack.docker-compose.bash --phase=down --app-name=hello-python-lambda

hello-python-lambda-localstack_compose-down-clean:
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/hello-python-lambda.locakstack.docker-compose.bash --phase=down-clean --app-name=hello-python-lambda


# ----------------------------------------------
# Build and deploy lambda functions via Bash scripts
# ----------------------------------------------
.PHONY: hello-python-lambda_localstack-deploy

hello-python-lambda_localstack-deploy:
	@bash $(INFRA_SERVER_TEMPLATING_DOCKER_SCRIPTS)/simple-lambda.bash --phase=build --app-name=hello-python-lambda
	@bash $(INFRA_PROVISIONING_SCRIPTS)/python-lambda.localstack.bash --phase=deploy --app-name=hello-python-lambda


# ----------------------------------------------
# Build and deploy lambda functions via Terraform
# ----------------------------------------------
.PHONY: hello-python-lambda-tf_init \
		hello-python-lambda-tf_apply \
		hello-python-lambda-tf_destroy

hello-python-lambda-tf_init:
	@bash $(INFRA_PROVISIONING_TERRAFORM_DIR)/simple-lambda.bash --phase=tf-init --app-name=hello-python-lambda

hello-python-lambda-tf_apply:
	@bash $(INFRA_SERVER_TEMPLATING_DOCKER_SCRIPTS)/simple-lambda.bash --phase=build --app-name=hello-python-lambda
	@bash $(INFRA_PROVISIONING_TERRAFORM_DIR)/simple-lambda.bash --phase=tf-apply --app-name=hello-python-lambda

hello-python-lambda-tf_destroy:
	@bash $(INFRA_PROVISIONING_TERRAFORM_DIR)/simple-lambda.bash --phase=tf-destroy --app-name=hello-python-lambda
