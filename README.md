# casa

## setup

### prerequisites
* x11 (you must be in an x11 session)
* git (`sudo apt-get install git`)
* curl (`sudo apt-get install curl`)
* make (`sudo apt-get install build-essential`)
* docker (`make install-docker`, then reboot)
* did you reboot?

## usage
* `git clone https://github.com/pwoolvett/casa-docker`
* `cd casa-docker`
* `make`
* grab a coffe (~10min)
* you are now inside a shell with `casa`, `casaviewer`, etc installed. launch any

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

## LICENSE

MIT - but should check on casa's license!
