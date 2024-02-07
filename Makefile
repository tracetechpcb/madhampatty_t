# Define the image name and tag
IMAGE_NAME=tracetech
TAG=latest
CONTAINER_NAME=tracetechcontainer
HOSTNAME := $(shell hostname)

# Build the Docker image
build:
	docker build -t $(IMAGE_NAME):$(TAG) --no-cache -f Dockerfile .

# Run a container from a image for the first time
run:
	docker run -h ${HOSTNAME} --name ${CONTAINER_NAME} -d -p 8000:8000 ${IMAGE_NAME}:${TAG}

# Start a stopped container
start:
	docker cp application/ ${CONTAINER_NAME}:/
	docker start ${CONTAINER_NAME}

# Stop a running container
stop:
	docker stop ${CONTAINER_NAME}

remove:
	docker rm ${CONTAINER_NAME} || true

# Clean up (optional)
clean:stop
	docker rm ${CONTAINER_NAME} || true
	docker rmi $(IMAGE_NAME):$(TAG) || true

