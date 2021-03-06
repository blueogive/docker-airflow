.PHONY : docker-prune docker-check docker-build docker-push

PIP_REQ_FILE := pip-req.txt
# PIP_REQ_FILE := pip-req-no-version.txt
IMG_NAME := docker-airflow
VCS_URL := $(shell git remote get-url --push gh)
VCS_REF := $(shell git rev-parse --short HEAD)
BUILD_DATE := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
TAG_DATE := $(shell date -u +"%Y%m%d")
AZ_RG_ACR := rg-infra
AZ_ACR_NAME := acrore
AZ_ACR_ZONE := ${AZ_ZONE}

docker-prune :
	@echo Pruning Docker images/containers/networks not in use
	docker system prune

docker-check :
	@echo Computing reclaimable space consumed by Docker artifacts
	docker system df

az-build: Dockerfile ${PIP_REQ_FILE}
	@az acr build \
	--registry ${AZ_ACR_NAME} \
	--build-arg PIP_REQ_FILE=$(PIP_REQ_FILE) \
	--build-arg VCS_URL=$(VCS_URL) \
	--build-arg VCS_REF=$(VCS_REF) \
	--build-arg BUILD_DATE=$(BUILD_DATE) \
	-t ${IMG_NAME}:$(TAG_DATE) \
	-t ${IMG_NAME}:latest .

docker-build: Dockerfile ${PIP_REQ_FILE}
	@docker build \
	--build-arg PIP_REQ_FILE=$(PIP_REQ_FILE) \
	--build-arg VCS_URL=$(VCS_URL) \
	--build-arg VCS_REF=$(VCS_REF) \
	--build-arg BUILD_DATE=$(BUILD_DATE) \
	--tag blueogive/${IMG_NAME}:$(TAG_DATE) \
	--tag blueogive/${IMG_NAME}:latest .

docker-push : docker-build
	@docker push blueogive/${IMG_NAME}:$(TAG_DATE)
	@docker push blueogive/${IMG_NAME}:latest
