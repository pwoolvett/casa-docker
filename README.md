# casa

## setup

### prerequisites

* x11 (you must be in an x11 session)
* make (`sudo apt-get install build-essential`)
* host deps:
    * Alternaitve A: install all with `make host-deps`
    * Alternative B: manually, or non-debian:
        * git (`sudo apt-get install git`)
        * curl (`sudo apt-get install curl`)
        * docker (`make install-docker`, then reboot)
    * reboot
* did you reboot?

## install
* `git clone https://github.com/pwoolvett/casa-docker`
* `cd casa-docker`
* Manually check the vars in the `Makefile`
    * `DISPLAY`: validate with `printenv DISPLAY`
    * `CASA_VERSION`: default 6.7 works. To change, select from [casa distro link](https://casa.nrao.edu/download/distro/casa/release/rhel/)
* `make`
* grab a coffe (~10min)

## usage
* After the `make`, you are now inside a shell with `casa`, `casaviewer`, etc installed. launch any
* The container runs in the background - you can kill it with `make stop`
* Tf you want to reconnect again, just run `make bash`

## Comments on paths and volume mounts

You'll need to use container paths in code/ui.

Volumes are mounted from host to container, see `compose.yml`. Example

```yaml
    volumes:
      - ${PWD}/casa:/home/${USERNAME}/.casa
      - ${PWD}/data:/home/${USERNAME}/data
```

This means the `./data` folder (besides this README) lives in `~/data` in the container

## TODO
* cleanup compose: too many privileges
* cleanup dockerfile: too many deps
* detect wayland host and setup qt env vars
* what fuse is needed on host?

## LICENSE

MIT - but should check on casa's license!
