# Get current version from VERSION.ver file..
GETVERSION = $(shell cat ${VERSION_FULL})

# CONSTS
IMAGE_NAME = tle-acquisition
IMAGE_FULL_NAME = thelotter/$(IMAGE_NAME)
CHART_PATH = /deploy/acquisition
CHART_FULL_NAME= $(IMAGE_NAME)-chart


build:
	echo "Build ping-service started."
	echo "${DOCKER_TOKEN}" | docker login --username ${DOCKER_USERNAME} --password-stdin
	docker build --tag $(IMAGE_FULL_NAME):$(GETVERSION) -f $(PATH_FULL)/Dockerfile .

deploy:
	echo "deploy phase"