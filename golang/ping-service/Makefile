# Get current version from VERSION.ver file..
GETVERSION = $(shell cat ${VERSION_FILE})

# CONSTS
IMAGE_NAME = ping-service
IMAGE_FULL_NAME = alexc94/$(IMAGE_NAME)
CHART_PATH = /deploy
CHART_FULL_NAME= $(IMAGE_NAME)-chart


build:
	echo "Build ping-service started."
	echo "${DOCKER_TOKEN}" | docker login --username ${DOCKER_USERNAME} --password-stdin
	docker build --tag $(IMAGE_FULL_NAME):$(GETVERSION) -f $(DIR)/Dockerfile .
	echo "Build ping-service finished."
deploy:
	echo "deploy phase"