DOCKER := docker
DOCKER_COMPOSE := docker-compose
PROJECT_NAME := tracetech
TAR := tar
TAR_FILE := $(PROJECT_NAME).tar

# Targets
.PHONY: build startup-script up start stop logs ps clean package

build:
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) build --no-cache

startup-script:
	./startup-scripts/main.sh ${PROJECT_NAME}
	./startup-scripts/check-container.sh ${PROJECT_NAME}

up:
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) up --remove-orphans -d
	sleep 15

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