# Get current version from VERSION.ver file..
GETVERSION = $(shell cat ${VERSION_FILE})

# CONSTS
IMAGE_NAME = ping-service
IMAGE_FULL_NAME = alexc94/$(IMAGE_NAME)
CHART_FULL_NAME= $(IMAGE_NAME)-chart

build:
	echo "Build $(IMAGE_NAME) started."
	echo "${DOCKER_TOKEN}" | docker login --username ${DOCKER_USERNAME} --password-stdin
	docker build --tag $(IMAGE_FULL_NAME):$(GETVERSION) -f $(DIR)/Dockerfile .
	echo "Build $(IMAGE_NAME) finished."
deploy:
	echo "Start $(IMAGE_NAME) deploy phase."
	echo "::set-output name=ping-service::ping-service"
#	git checkout -b deploy-$(IMAGE_NAME)-$(GETVERSION)
	echo "Finish $(IMAGE_NAME) deploy phase."