include .env
# Start containers, no theme files will be included
start:
	docker-compose -f ./docker/docker-compose.yml up -d --build

febuild: 
	@sudo npm run build

build: febuild
	@bash ./shell/get_src_files.sh


bkp-plugins:
	@sudo bash ./shell/backup_plugins.sh

bkp-uploads:
	@sudo bash ./shell/backup_uploads.sh

bkp: 
	@sudo bash ./shell/backup_plugins.sh
	@sudo bash ./shell/backup_uploads.sh

down: bkp
	docker-compose -f ./docker/docker-compose.yml down -v 

deploy: start
	docker-compose -f ./docker/docker-compose.yml -f ./docker/config/wp-auto-config.yml run --rm wp-auto-config

install: deploy
	@sudo npm install

clean: down
	@echo "💥 Removing related folders/files..."
	@sudo rm -rf  mysql/* wordpress/*
