start:
	docker build -f frontend/Dockerfile.dev ./frontend

start-compose:
	docker-compose -f frontend/docker-compose.yml down && docker-compose -f frontend/docker-compose.yml up --build

build: 
	docker build frontend/.

# to run the built image `docker run -p 8080:80 "sha256 code"`
# the "sha256 code" is from the last output of the image build
