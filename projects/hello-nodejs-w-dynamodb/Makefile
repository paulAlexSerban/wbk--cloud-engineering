INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR := ./infrastructure/orchestration/docker

hello-nodejs-w-dynamodb-compose-up:
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/base.nodejs.docker-compose.bash --phase=up --app-name=hello-nodejs-w-dynamodb

hello-nodejs-w-dynamodb-compose-down:
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/base.nodejs.docker-compose.bash --phase=down --app-name=hello-nodejs-w-dynamodb

hello-nodejs-w-dynamodb-compose-down-clean:
	@bash $(INFRA_ORCHESTRATION_SCRIPTS_DOCKER_DIR)/base.nodejs.docker-compose.bash --phase=down-clean --app-name=hello-nodejs-w-dynamodb

