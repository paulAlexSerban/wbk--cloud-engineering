
INFRA_PROVISIONING_SCRIPTS := ./infrastructure/provisioning/scripts
INFRA_SERVER_TEMPLATING_DOCKER_SCRIPTS := ./infrastructure/server-templating/docker
INFRA_PROVISIONING_TERRAFORM_DIR := ./infrastructure/provisioning/terraform
INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR := ./infrastructure/orchestration/docker

# ----------------------------------------------
# Start localstack services
# ----------------------------------------------
.PHONY: hello-lambda-localstack_compose-up \
		hello-lambda-localstack_compose-down \
		hello-lambda-localstack_compose-down-clean

hello-lambda-localstack_compose-up: 
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/lambda.locakstack.docker-compose.bash --phase=up --app-name=hello-lambda

hello-lambda-localstack_compose-down:
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/lambda.locakstack.docker-compose.bash --phase=down --app-name=hello-lambda

hello-lambda-localstack_compose-down-clean:
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/lambda.locakstack.docker-compose.bash --phase=down-clean --app-name=hello-lambda


# ----------------------------------------------
# Build and deploy lambda functions via Bash scripts
# ----------------------------------------------
.PHONY: hello-lambda_localstack-deploy

hello-lambda_localstack-deploy:
	@bash $(INFRA_SERVER_TEMPLATING_DOCKER_SCRIPTS)/simple-lambda.bash --phase=build --app-name=hello-lambda
	@bash $(INFRA_PROVISIONING_SCRIPTS)/simple-lambda.localstack.bash --phase=deploy --app-name=hello-lambda


# ----------------------------------------------
# Build and deploy lambda functions via Terraform
# ----------------------------------------------
.PHONY: hello-lambda-tf_init \
		hello-lambda-tf_apply \
		hello-lambda-tf_destroy

hello-lambda-tf_init:
	@bash $(INFRA_PROVISIONING_TERRAFORM_DIR)/simple-lambda.bash --phase=tf-init --app-name=hello-lambda

hello-lambda-tf_apply:
	@bash $(INFRA_SERVER_TEMPLATING_DOCKER_SCRIPTS)/simple-lambda.bash --phase=build --app-name=hello-lambda
	@bash $(INFRA_PROVISIONING_TERRAFORM_DIR)/simple-lambda.bash --phase=tf-apply --app-name=hello-lambda

hello-lambda-tf_destroy:
	@bash $(INFRA_PROVISIONING_TERRAFORM_DIR)/simple-lambda.bash --phase=tf-destroy --app-name=hello-lambda
