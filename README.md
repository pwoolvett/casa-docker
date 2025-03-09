# casa

## setup

### prerequisites

* x11 (you must be in an x11 session)
* Wayland: you may try a wayland session after succesfully building the container and running `casa` in an x11 session
* make (`sudo apt-get install build-essential`)
* git (`sudo apt-get install git`)
* curl (`sudo apt-get install curl`)

### install
Make a directory where you want to clone this repository (`mkdir /path/before/casa-docker`)
* `cd /path/before/casa-docker`
* `git clone https://github.com/pwoolvett/casa-docker`
* `cd casa-docker`
* `make host-deps` (this will install `docker` if not available)
* IMPORTANT: if you did not have docker already installed, reboot at this point.
* Manually check the vars in the `Makefile`
    * `DISPLAY`: validate with `printenv DISPLAY`
    * `CASA_VERSION`: default 6.7 works. To change, select from [casa distro link](https://casa.nrao.edu/download/distro/casa/release/rhel/)
* Run `make`
* grab a coffee (~10 min)

## usage
* After the `make`, you are now inside a shell with `casa`, `casaviewer`, etc installed. Launch any.
  * If this is the first time running CASA, it will automatically populate the `~/.casa/data` directory with [External Data](https://casadocs.readthedocs.io/en/stable/notebooks/external-data.html).
  * This `~/.casa/data` directory is re-populated on a daily basis. Expect automatic downloads when running casa every day or so.
* The container runs in the background - you can exit with CTRL+D or `exit`, or kill it with `make stop` in host terminal.
* If you want to reconnect again, **and the container is not stopped** (no `make stop`), just run `make connect`.

## Comments on installed packages in container
You may want to add additional packages to this docker container. To do so:
* Make a back-up Dockerfile: `cp Dockerfile Dockerfile.bkp`
* Edit the default Dockerfile with a text editor: e.g. `nano Dockerfile` or `gedit Dockerfile`
* Locate the comment `# install ANY other package (personal use or debugging)`
* add your package as:
```yaml
RUN : \
  && apt-get install -y \  # install instruction, accepting any prompts with -y option
  nano \  # This adds a commonly used text editor to the container by default
  YOUR-PACKAGE 1 \  # here you may add additional packages
  YOUR-PACKAGE 2 \  # package 2, etc.
  && :   
```
* Save the Dockerfile, and run `make` again.

## Comments on paths and volume mounts

You'll need to use container paths in code/ui.

Volumes are mounted from host to container, see `compose.yml`. Example

```yaml
    volumes:
      - ${PWD}/casa:/home/${USERNAME}/casa
      - ${PWD}/dotcasa:/home/${USERNAME}/.casa
```

This means the `./dotcasa` folder (besides this README) lives in `~/.casa` in the container

# TODO
* cleanup compose: too many privileges
* cleanup dockerfile: too many deps
* detect wayland host and setup qt env vars
* what fuse is needed on host?
* "make install" -> create bashrc alias to `cd && make`

## LICENSE

MIT - but should check on casa's license!
