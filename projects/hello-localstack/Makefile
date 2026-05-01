INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR := ./infrastructure/orchestration/docker

# ----------------------------------------------
# Start localstack services
# ----------------------------------------------
.PHONY: hello-localstack_compose-up \
		hello-localstack_compose-down \
		hello-localstack_compose-down-clean

hello-localstack_compose-up: 
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/hello.locakstack.docker-compose.bash --phase=up --app-name=hello-localstack

hello-localstack_compose-down:
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/hello.locakstack.docker-compose.bash --phase=down --app-name=hello-localstack

hello-localstack_compose-down-clean:
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/hello.locakstack.docker-compose.bash --phase=down-clean --app-name=hello-localstack
