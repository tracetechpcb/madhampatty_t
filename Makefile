# Define the image name and tag
IMAGE_NAME=tracetech
TAG=latest

# Build the Docker image
build:
	docker build -t $(IMAGE_NAME):$(TAG) -f Dockerfile .

# Clean up (optional)
clean:
	docker rmi $(IMAGE_NAME):$(TAG)
