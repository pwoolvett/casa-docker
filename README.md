# Casa

## Setup

### Prerequisites

* x11 (you must be in an x11 session)
* Wayland: you may try wayland after succesfully building the container and running `casa` in x11
* make (`sudo apt-get install build-essential`) for ease of use
* git (`sudo apt-get install git`)
* curl (`sudo apt-get install curl`)

### Install

Move to the directory where you want to clone this repository. There:
* `git clone https://github.com/pwoolvett/casa-docker`
* `cd casa-docker`
* `make host-deps` (install `docker` if not available)
* IMPORTANT: if you did not have docker already installed, reboot at this point.
* Manually check the vars in the `Makefile`
    * `DISPLAY`: validate with `printenv DISPLAY`. Uncomment and set if necessary.
    * `CASA_VERSION`: default 6.7 works. To change, select from [casa distro link](https://casa.nrao.edu/download/distro/casa/release/rhel/)
* Run `make`
* grab a coffee (~10 min)

## Usage

For ease of use, this docker container is installed and managed using `make` from the `build-essential` package you installed as a prerequisite, albeit not strictly necessary.

Basic `make` commands work in directories with a file `Makefile` specifying these commands. For this installation, you can only run its own `make` commands when the current working directory in the host machine is this `casa-docker` folder, which has a `Makefile` specifically configured to manage this docker container.

### Basic commands and information

* After the `make`, you are now inside a shell with `casa`, `casaviewer`, etc. installed. Launch any.
  * If this is the first time running CASA, it will automatically populate `~/.casa/data` with [External Data](https://casadocs.readthedocs.io/en/stable/notebooks/external-data.html).
  * The `~/.casa/data` directory is updated daily - expect automatic downloads once a day.
* The container runs in the background - you can safely exit back to host shell with CTRL+D or `exit`.
* If you want to reconnect again (**and the container is not stopped**) run `make connect` in host shell.
* You may also kill/stop it with `make stop` in host shell, **but make sure that your (important) data is located inside a mounted volume** (explained in next section).
* Rebooting the host machine will kill the container in the background, but progess **inside mounted volumes** is saved.
* You may at some point want to erase the `~/.casa/data` folder used for External Data (e.g. network error while automatically downloading data at CASA startup). You can do so easily by running `make cleandata` in host.

### Comments on paths and volume mounts

* **Changes, such as new files of any kind, outside mounted folders/volumes will be erased after stopping the container!!!**
* Files in unmounted volumes are "temporary" - they exist while the container is running (in shell) or in the background (i.e. **not stopped**).
* The /home/username folder itself inside the container is not mounted to host by default, so new files in container home are deleted when container is stopped.
* It is therefore recommended to run `casa` inside the /home/username/casa folder or other mounted volumes, as the usual `task.last` files for tasks run in CASA will be saved to the current working directory, which is presumably a real (not temporary) directory.
* **You can safely create new folders and files within mounted volumes, from either host or container, as mounted volumes are synchronized in real time with the specified (`compose.yml`) folders in host.**

You'll need to use container paths in code/ui to mount new folders.

Volumes are mounted from host to container, see `compose.yml`. Example:

```yaml
    volumes:
      - ${PWD}/casa:/home/${USERNAME}/casa
      - ${PWD}/dotcasa:/home/${USERNAME}/.casa
```

This means the `./dotcasa` folder (besides this README) lives in `~/.casa` in the container.

**Read the READMEs inside `./casa` and `./dotcasa` for more information on these default folders and how to move them safely.**

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
  * Expect some small delay, as Docker will have to install your new packages into the container.
  * As this step is almost at the end of the Dockerfile, Docker will skip all previous steps if the container was previously built (setting up the virtual OS, downloading and insalling CASA and its prerequisites, etc.) and only re-do this RUN where user packages are installed - no coffee, sorry.
* If something does not work, you may have touched another line or entered the wrong format.
  * Delete the Dockerfile `rm Dockerfile` and rename the backup `mv Dockerfile.bkp Dockerfile`
  * Try again from start (*Make a backup Dockerfile:*)

## TODO
vwoolvett TODO & questions. I will create a separate branch to test some of these:
* vwoolvett: I may be completely wrong, but I noticed the following: We should make a method in Makefile to only run `docker compose up -d casa`. Why? bc the `build` is only necessary when changing stuff for the container, but typical usage would be:
  * User does `make` (running `make compose`) the very first time, container is 1:built, 2:started (`docker compose up -d casa`) and 3:shell is opened
  * User does whatever inside (use CASA for example), then exits container and may stop it with `make stop` to power off the PC, though it is automatically stopped if host powers off.
  * Next day, turns the PC on and has tu run `make` again **but only because the container is not running**, and I think in 99% of the cases building the container again is unnecessary, he would just need to get it running with `compose up` and then connect to shell.
* So, proposed change:
  * `make compose` does what it does already, (re)builds the image, runs the container and opens shell. Perhaps rename it to `make build`? Would be more intuitive.
  * `make connect` (old `make bash`) does what it does already, just opens the container shell if the casa container is running.
  * Add a method, something like `make start` that only runs `docker compose up -d casa`, displaying the "tick, casa container is running"
  
* By the way, how does `make` know it has to run `make compose` and not any other method inside Makefile? -> Nevermind, first method without a dot is ran with `make`

* vwoolvett: We should add uninstall procedure in Makefile to remove the container/image and/or reinstall from scratch.
* vwoolvett: We could add the option to install an ALMA pipeline version of CASA (for raw data calibration and imaging), instead of a normal CASA version (image processing).
* vwoolvett: What happens when container is built, but CASA version is changed and container re-built? Mounted volumes won't be affected I presume, but does it affect anything else?

pwoolvett TODOs
* pwoolvett: cleanup compose: too many privileges
* pwoolvett: cleanup dockerfile: too many deps
* pwoolvett: detect wayland host and setup qt env vars
* pwoolvett: what fuse is needed on host? *vwoolvett: I installed libfuse2t64 (libfuse2 in ubuntu 24.04) to fix borders problem (fix was something else), but it was not necessary in the first place IMO.*
* pwoolvett: "make install" -> create bashrc alias to `cd && make`

## LICENSE

MIT - but should check on casa's license!
