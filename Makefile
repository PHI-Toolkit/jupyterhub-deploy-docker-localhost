# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
# Revision Date: 20180529

include .env

.DEFAULT_GOAL=build

network:
	@docker network inspect $(DOCKER_NETWORK_NAME) >/dev/null 2>&1 || docker network create $(DOCKER_NETWORK_NAME)

volumes:
	@docker volume inspect $(DATA_VOLUME_HOST) >/dev/null 2>&1 || docker volume create --name $(DATA_VOLUME_HOST)
	@docker volume inspect $(DB_VOLUME_HOST) >/dev/null 2>&1 || docker volume create --name $(DB_VOLUME_HOST)

self-signed-cert:
	# make a self-signed cert
	create-certs.sh

userlist:
	@echo "Add usernames, one per line, to ./userlist, such as:"
	@echo "    zoe admin"
	@echo "    wash"
	@exit 1

# Do not require cert/key files if SECRETS_VOLUME defined
secrets_volume = $(shell echo $(SECRETS_VOLUME))
ifeq ($(secrets_volume),)
	cert_files=secrets/jupyterhub.pem secrets/jupyterhub.key
else
	cert_files=
endif

check-files: userlist $(cert_files) .env

notebook_base:
	DOCKER_BUILDKIT=$(DOCKER_BUILDKIT) docker build -t $(LOCAL_NOTEBOOK_BASE) $(DOCKER_BUILD_CACHE_OPTION) \
		--build-arg LOGO_IMAGE=$(LOGO_IMAGE) \
		--build-arg JUPYTERHUB_VERSION=$(JUPYTERHUB_VERSION) \
		--build-arg JUPYTERLAB_VERSION=$(JUPYTERLAB_VERSION) \
		--build-arg NOTEBOOK_VERSION=$(NOTEBOOK_VERSION) \
		--build-arg DOCKER_NOTEBOOK_IMAGE=$(DOCKER_NOTEBOOK_IMAGE) \
		--build-arg JUPYTER_UI=$(JUPYTER_UI) \
		--file=singleuser/$(DOCKERFILE_BASE) singleuser

notebook_body:
	DOCKER_BUILDKIT=$(DOCKER_BUILDKIT) docker build -t $(LOCAL_NOTEBOOK_BODY) $(DOCKER_BUILD_CACHE_OPTION) \
		--build-arg JUPYTERHUB_VERSION=$(JUPYTERHUB_VERSION) \
		--build-arg JUPYTERLAB_VERSION=$(JUPYTERLAB_VERSION) \
		--build-arg NOTEBOOK_VERSION=$(NOTEBOOK_VERSION) \
		--file=singleuser/$(DOCKERFILE_BODY) singleuser

notebook_image: #pull singleuser/Dockerfile
	DOCKER_BUILDKIT=$(DOCKER_BUILDKIT) docker build -t $(LOCAL_NOTEBOOK_IMAGE) $(DOCKER_BUILD_CACHE_OPTION) \
		--build-arg LOGO_IMAGE=$(LOGO_IMAGE) \
		--build-arg JUPYTERHUB_VERSION=$(JUPYTERHUB_VERSION) \
		--build-arg JUPYTERLAB_VERSION=$(JUPYTERLAB_VERSION) \
		--build-arg NOTEBOOK_VERSION=$(NOTEBOOK_VERSION) \
		--build-arg NB_USER_PASS=$(NB_USER_PASS) \
		--build-arg GEN_CERT=$(GEN_CERT) \
		--build-arg MAPBOX_API_KEY=$(MAPBOX_API_KEY) \
		--file=singleuser/$(DOCKERFILE_TAIL) singleuser

build: check-files network volumes
	docker-compose build

.PHONY: network volumes check-files pull notebook_image build
