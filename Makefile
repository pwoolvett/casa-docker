
# manually set these
# DISPLAY=":0", set if different.
CASA_VERSION="casa-6.7.0-31-py3.12.el8"

USER_GID=$(shell id -g)
USER_UID=$(shell id -u)
USERNAME=$(shell whoami)

DOCKER := $(shell command -v docker)

.env: clean
	echo "USER_GID=$(USER_GID)" > .env
	echo "USER_UID=$(USER_UID)" >> .env
	echo "USERNAME=$(USERNAME)" >> .env
	echo "DISPLAY=$(DISPLAY)" >> .env
	echo "CASA_VERSION=$(CASA_VERSION)" >> .env

# first function without dot is assigned to command "make"=="make compose".
# This function builds the container and applies changes to other files.
# It also starts the container and opens a shell using function start.
compose: .env xhost
	docker compose build
	make start

# function to start container on host start-up, and/or connect to container shell
start: ensureborders
	docker compose up -d casa
	docker compose exec -w ~/casa -it casa bash

# function to stop the container
stop:
	docker compose kill || true
	docker compose down || true

host-deps:
	make install-docker

.docker-install-deps:
	sudo apt-get install -y \
	  curl

install-docker:
ifndef DOCKER
	make .docker-install-deps
	curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
	sudo sh /tmp/get-docker.sh
	sudo groupadd docker || true
	sudo usermod -aG docker $(USERNAME) || true
	echo "-------------- NOW REBOOT --------------"
endif

xhost:
	bash -c 'DISPLAY=:0 xhost +'

down:
	docker compose down

clean: stop
	rm .env || true

cleanexternaldata:
	rm -rf dotcasa/data/*

# For some host configurations, the windows of the CASA GUI have no borders.
# Main cause is that mutter did not initialize properly on system start-up.
# This function re-starts mutter.
ensureborders:
	pkill -HUP mutter-x11 || true
