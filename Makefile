
# manually set this
DISPLAY=":0"

USER_GID=$(shell id -g)
USER_UID=$(shell id -u)
USERNAME=$(shell whoami)

.env: clean
	echo "USER_GID=$(USER_GID)" > .env
	echo "USER_UID=$(USER_UID)" >> .env
	echo "USERNAME=$(USERNAME)" >> .env
	echo "DISPLAY=$(DISPLAY)" >> .env

compose: .env xhost down 

	docker compose build
	docker compose up -d casa
	docker compose exec -it casa bash

attach:
	docker compose exec -it casa bash


install-docker:
	curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
	sudo sh /tmp/get-docker.sh
	sudo groupadd docker || true
	sudo usermod -aG docker $(USERNAME) || true
	echo "now reboot or logout"

xhost:
	bash -c 'DISPLAY=:0 xhost +'

down:
	docker compose down

clean:
	docker compose kill || true
	docker compose down || true
	rm .env || true

cleandata:
	rm -rf data
