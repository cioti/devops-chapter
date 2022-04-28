# Get current version from VERSION.ver file.
GETVERSION = $(shell cat ${VERSION_FILE})

# CONSTS
IMAGE_NAME = pong-service
IMAGE_FULL_NAME = alexc94/$(IMAGE_NAME)
CHART_FULL_NAME= $(IMAGE_NAME)-chart

build:
	echo "Build $(IMAGE_NAME) started."
	docker build --tag $(IMAGE_FULL_NAME):$(GETVERSION) -f $(DIR)/Dockerfile .
	echo "Build $(IMAGE_NAME) finished."
release:
	echo "Start $(IMAGE_NAME) release phase."
#   increment current service version from VERSION.ver file
	$(eval VERSION=$(shell sudo ./semver.sh $(VERSION_FILE) release-patch))
#	replace both appversion & chart version
	sudo yq e '.appVersion = "$(GETVERSION)"' -i $(DIR)/deploy/Chart.yaml
	sudo yq e '.version = "$(GETVERSION)"' -i $(DIR)/deploy/Chart.yaml
	git config --global user.email "service@account.net"
	git config --global user.name "service_account"
	git add -A '*.ver'
	git add -A '*.yaml'
	git commit -m "version bump $(GETVERSION)"
	git push origin HEAD
	echo "${DOCKER_TOKEN}" | docker login --username ${DOCKER_USERNAME} --password-stdin
	docker build --tag $(IMAGE_FULL_NAME):$(GETVERSION) -f $(DIR)/Dockerfile .
	docker push $(IMAGE_FULL_NAME):$(GETVERSION)
#   this is my ChartMuseum service hosted in my cluster
	helm repo add alex-charts http://alexpc.ddnsking.com:8080
	helm repo update
	helm package $(DIR)/deploy --dependency-update
	wget --post-file $(CHART_FULL_NAME)-$(GETVERSION).tgz http://alexpc.ddnsking.com:8080/api/charts
#	this sets output like "pong-service=pong-service:1.0.0" which will be used by deploy script in git action.
	echo "::set-output name=$(IMAGE_NAME)::$(IMAGE_NAME):$(GETVERSION)"
	echo "Finish $(IMAGE_NAME) release phase."