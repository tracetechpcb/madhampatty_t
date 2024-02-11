# Define the image name and tag
IMAGE_NAME=tracetech
TAG=latest
CONTAINER_NAME=tracetechcontainer
HOSTNAME := $(shell hostname)

# Build the Docker image
build:
	docker build -t $(IMAGE_NAME):$(TAG) --no-cache -f Dockerfile .

# Copy necessary files to container to reflect any changes
copy:
	docker cp entrypoint.sh ${CONTAINER_NAME}:/application
	docker cp mariadb_default_init.sh ${CONTAINER_NAME}:/application
	docker cp mariadb_custom_init.sh ${CONTAINER_NAME}:/application
	docker cp mariadb_upgrade_init.sh ${CONTAINER_NAME}:/application
	docker cp tracetech/ ${CONTAINER_NAME}:/application

# Run a container from a image for the first time
run:
	docker run -h ${HOSTNAME} --name ${CONTAINER_NAME} -d -p 80:80 -p 8000:8000 -v mysql_vol:/var/lib/mysql ${IMAGE_NAME}:${TAG}

# Start a stopped container
start:copy
	docker start ${CONTAINER_NAME}

# Stop a running container
stop:
	docker stop ${CONTAINER_NAME}

remove:
	docker rm ${CONTAINER_NAME} || true

# Clean up (optional)
clean:
	docker rmi $(IMAGE_NAME):$(TAG) || true

