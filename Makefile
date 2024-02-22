DOCKER := docker
DOCKER_COMPOSE := docker-compose
PROJECT_NAME := tracetech
TAR := tar
PACKAGE_FOLDER := package

# Targets
.PHONY: build startup-script up start stop logs ps clean package

build:
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) build --no-cache

startup-script:
	sleep 15
	./startup-scripts/main.sh ${PROJECT_NAME}

up:
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) up --remove-orphans -d

start: up startup-script

stop:
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) down

logs:
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) logs -f

ps:
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) ps

clean:
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) down --rmi local
	docker image prune -a

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