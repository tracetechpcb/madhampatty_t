DOCKER := docker
DOCKER_COMPOSE := docker-compose
PROJECT_NAME := tracetech
TAR := tar
PACKAGE_FOLDER := package


# Build target has 'pre-build' stage followed by actual build followed by 'post-puild' stage
build: pre-build docker-compose-build post-build

pre-build:
	python3 ./pre-build.py
	python3 ./nginx-service/pre-build.py

docker-compose-build:
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) build --no-cache

post-build:
	python3 ./nginx-service/post-build.py


# Start target has 'pre-start' stage followed by actual start followed by 'post-start' stage
start: pre-start docker-compose-up post-start

pre-start:
	:

docker-compose-up:
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) up --remove-orphans -d

post-start:
	:


# Other targets
stop:
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) down

logs:
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) logs -f

ps:
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) ps

clean:
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) down --rmi local
	docker image prune -a


# Targets related to builing tar package and deploying them
package: build
	mkdir -p $(PACKAGE_FOLDER)
	${DOCKER} save -o $(PACKAGE_FOLDER)/img_mariadb.tar img_mariadb
	${DOCKER} save -o $(PACKAGE_FOLDER)/img_mongodb.tar img_mongodb
	${DOCKER} save -o $(PACKAGE_FOLDER)/img_nginx.tar img_nginx
	${DOCKER} save -o $(PACKAGE_FOLDER)/img_react.tar img_react
	${DOCKER} save -o $(PACKAGE_FOLDER)/img_gunicorn.tar img_gunicorn
	cp -r .env $(PACKAGE_FOLDER)
	cp -r Makefile $(PACKAGE_FOLDER)
	cp -r docker-compose.yml $(PACKAGE_FOLDER)
	cp -r Dockerfile.* $(PACKAGE_FOLDER)
	cp -r startup-scripts $(PACKAGE_FOLDER)
	cp -r nginx-service $(PACKAGE_FOLDER)
	tar -czvf ${PACKAGE_FOLDER}.tar.gz ${PACKAGE_FOLDER}


image-load:
	${DOCKER} load -i img_mariadb.tar
	${DOCKER} load -i img_mongodb.tar
	${DOCKER} load -i img_nginx.tar
	${DOCKER} load -i img_react.tar
	${DOCKER} load -i img_gunicorn.tar

package-deploy: image-load start