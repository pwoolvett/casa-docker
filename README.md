# casa

## setup

### prerequisites
* git
* curl
* x11
* make
* docker (`make install-docker`)

## usage
* `git clone https://github.com/pwoolvett/casa-docker`
* `cd casa-docker`
* `make`

## Comments on paths and volume mounts

You'll need to used container paths in code/ui.

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
