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

secrets/postgres.env:
	@echo "Generating postgres password in $@"
	@echo "POSTGRES_PASSWORD=$(shell openssl rand -hex 32)" > $@

secrets/oauth.env:
	@echo "Need oauth.env file in secrets with GitHub parameters"
	@exit 1

secrets/jupyterhub.crt:
	@echo "Need an SSL certificate in secrets/jupyterhub.crt"
	@exit 1

secrets/jupyterhub.key:
	@echo "Need an SSL key in secrets/jupyterhub.key"
	@exit 1

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

pull:
	docker pull $(DOCKER_NOTEBOOK_IMAGE)

notebook_base:
	docker build -t $(LOCAL_NOTEBOOK_BASE) \
		--build-arg LOGO_IMAGE=$(LOGO_IMAGE) \
		--build-arg JUPYTERHUB_VERSION=$(JUPYTERHUB_VERSION) \
		--build-arg JUPYTERLAB_VERSION=$(JUPYTERLAB_VERSION) \
		--build-arg NOTEBOOK_VERSION=$(NOTEBOOK_VERSION) \
		--build-arg DOCKER_NOTEBOOK_IMAGE=$(DOCKER_NOTEBOOK_IMAGE) \
		--build-arg NB_USER_PASS=$(NB_USER_PASS) \
		--build-arg GITHUB_ACCESS_TOKEN=$(GITHUB_ACCESS_TOKEN) \
		--build-arg GITHUB_CLIENT_ID=$(GITHUB_CLIENT_ID) \
		--build-arg GITHUB_CLIENT_SECRET=$(GITHUB_CLIENT_SECRET) \
		--file=$(DOCKERFILE_BASE) singleuser

notebook_body:
	docker build -t $(LOCAL_NOTEBOOK_BODY) \
		--build-arg LOGO_IMAGE=$(LOGO_IMAGE) \
		--build-arg JUPYTERHUB_VERSION=$(JUPYTERHUB_VERSION) \
		--build-arg JUPYTERLAB_VERSION=$(JUPYTERLAB_VERSION) \
		--build-arg NOTEBOOK_VERSION=$(NOTEBOOK_VERSION) \
		--build-arg DOCKER_NOTEBOOK_IMAGE=$(DOCKER_NOTEBOOK_IMAGE) \
		--build-arg NB_USER_PASS=$(NB_USER_PASS) \
		--build-arg GITHUB_ACCESS_TOKEN=$(GITHUB_ACCESS_TOKEN) \
		--build-arg GITHUB_CLIENT_ID=$(GITHUB_CLIENT_ID) \
		--build-arg GITHUB_CLIENT_SECRET=$(GITHUB_CLIENT_SECRET) \
		--file=singleuser/$(DOCKERFILE) singleuser

notebook_image: #pull singleuser/Dockerfile
	docker build -t $(LOCAL_NOTEBOOK_IMAGE) \
		--build-arg LOGO_IMAGE=$(LOGO_IMAGE) \
		--build-arg JUPYTERHUB_VERSION=$(JUPYTERHUB_VERSION) \
		--build-arg JUPYTERLAB_VERSION=$(JUPYTERLAB_VERSION) \
		--build-arg NOTEBOOK_VERSION=$(NOTEBOOK_VERSION) \
		--build-arg DOCKER_NOTEBOOK_IMAGE=$(DOCKER_NOTEBOOK_IMAGE) \
		--build-arg NB_USER_PASS=$(NB_USER_PASS) \
		--build-arg GITHUB_ACCESS_TOKEN=$(GITHUB_ACCESS_TOKEN) \
		--build-arg GITHUB_CLIENT_ID=$(GITHUB_CLIENT_ID) \
		--build-arg GITHUB_CLIENT_SECRET=$(GITHUB_CLIENT_SECRET) \
		--file=singleuser/$(DOCKERFILE_TAIL) singleuser

build: check-files network volumes
	docker-compose build

.PHONY: network volumes check-files pull notebook_image build
