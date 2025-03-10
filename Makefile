
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
compose: .env xhost ensureborders
	docker compose build
	docker compose up -d casa
	docker compose exec -it casa bash

# function to run on system start-up: starts the casa container.
start: ensureborders
	docker compose up -d casa

# function to re-open the shell if the container is running
connect:
	docker compose exec -it casa bash

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

# function to stop the container
stop:
	docker compose kill || true
	docker compose down || true

clean: stop
	rm .env || true

cleanexternaldata:
	rm -rf dotcasa/data/*

# Reinitialize mutter to ensure borders on hosts with GNOME ~46. Ignore related warnings if any.
ensureborders:
	pkill -HUP mutter-x11
