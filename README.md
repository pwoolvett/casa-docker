# Casa

## Setup

### Prerequisites

* x11 (you must be in an x11 session)
* Wayland: you may try wayland after succesfully building the container and running `casa` in x11
* make (`sudo apt-get install build-essential`)
* git (`sudo apt-get install git`)
* curl (`sudo apt-get install curl`)

### Install
Move to the directory where you want to clone this repository. There:
* `git clone https://github.com/pwoolvett/casa-docker`
* `cd casa-docker`
* `make host-deps` This will install `docker` if not available. **If available, run anyways to clean dummmy files.**
* IMPORTANT: if you did not have docker already installed, reboot at this point.
* Manually check the vars in the `Makefile`
    * `DISPLAY`: validate with `printenv DISPLAY`. Uncomment and set if necessary.
    * `CASA_VERSION`: default 6.7 works. To change, select from [casa distro link](https://casa.nrao.edu/download/distro/casa/release/rhel/)
* Run `make`
* grab a coffee (~10 min)

## Usage

### Basic commands and information

* After the `make`, you are now inside a shell with `casa`, `casaviewer`, etc. installed. Launch any.
  * If this is the first time running CASA, it will automatically populate `~/.casa/data` with [External Data](https://casadocs.readthedocs.io/en/stable/notebooks/external-data.html).
  * The `~/.casa/data` directory is re-populated daily - expect automatic downloads once a day.
* The container runs in the background - you can exit back to host shell with CTRL+D or `exit`.
* If you want to reconnect again (**and the container is not stopped**) run `make connect` in host shell.
* You may also safely kill/stop it with `make stop` in host shell.
* Rebooting the host machine will also kill the shell in the background, but progess **inside mounted volumes** is saved.

### Comments on paths and volume mounts

You'll need to use container paths in code/ui.

Volumes are mounted from host to container, see `compose.yml`. Example:

```yaml
    volumes:
      - ${PWD}/casa:/home/${USERNAME}/casa
      - ${PWD}/dotcasa:/home/${USERNAME}/.casa
```

This means the `./dotcasa` folder (besides this README) lives in `~/.casa` in the container.

### Comments on installed packages in container
You may want to add additional packages to this docker container. To do so:
* Make a backup Dockerfile: `cp Dockerfile Dockerfile.bkp`
* Edit the default Dockerfile with a text editor: e.g. `nano Dockerfile` or `gedit Dockerfile`
* Locate the comment `# install ANY other package (personal use or debugging)`
* add your package as (ignore comments in actual Dockerfile):

```yaml
# install ANY other package (personal use or debugging)
RUN : \                    # This RUN sets a specific step "n/N" in the container building process
  && apt-get install -y \  # install instruction, accepting any prompts with -y option
  nano \                   # This adds a commonly used text editor to the container (default)
  YOUR-PACKAGE-1 \         # here you may add additional packages
  YOUR-PACKAGE-2 \         # package 2, etc.
  && :                     # This line MUST be at the end
```

* **Save the Dockerfile and run** `make` **again**.
  * Expect some delay, Docker will have to install your new packages into the container.
  * As this step is almost at the end of the Dockerfile, Docker will skip all previous steps and only re-do this RUN where user packages are installed - no coffee, sorry.
* If something does not work, you may have touched another line or entered the wrong format.
  * Delete the Dockerfile `rm Dockerfile` and rename the backup `mv Dockerfile.bkp Dockerfile`
  * Try again from start (*Make a backup Dockerfile:*)

# TODO
* cleanup compose: too many privileges
* cleanup dockerfile: too many deps
* detect wayland host and setup qt env vars
* what fuse is needed on host?
* "make install" -> create bashrc alias to `cd && make`

## LICENSE

MIT - but should check on casa's license!
