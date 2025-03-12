# Casa

Run **CASA, the Common Astronomy Software Applications** from `docker`.

Say goodbye to running CASA full of warnings and errors by simulating an OS with the proper CASA library and OS prerequisites.
Works as fast as your host machine.

## Setup

### Prerequisites

* ubuntu or ubuntu-based os with x11 (you must be in an x11 session)
* Wayland: you may try wayland after succesfully building the container and running `casa` in x11
* make (`sudo apt-get install build-essential`) for ease of use
* git (`sudo apt-get install git`)
* curl (`sudo apt-get install curl`)

### Install

Move to the directory where you want to clone this repository. Once there:
* `git clone https://github.com/pwoolvett/casa-docker`
* `cd casa-docker`
* `make host-deps` (this installs `docker` if not available)
* **IMPORTANT:** if you did not have docker already installed, reboot at this point.
* Manually check the vars in the `Makefile`
    * `DISPLAY`: validate with `printenv DISPLAY`. Uncomment and set if necessary.
    * `CASA_VERSION`: default 6.7 works. To change, select from [casa distro link](https://casa.nrao.edu/download/distro/casa/release/rhel/).
* Run `make`
* grab a coffee (~10 min)

## Usage

For ease of use, this docker container is installed and managed with `docker compose` using `make` commands from the `build-essential` package you installed as a prerequisite, albeit not strictly necessary.

Basic `make` commands work in directories with a file `Makefile` specifying these commands. For this installation, you can just run `make` in the root directory where this repo is cloned to in host. Inside this `casa-docker` folder there's a `Makefile` specifically configured to manage this docker container via `docker compose` commands.

### Basic commands and information

* After the `make`, you are now inside a shell with `casa`, `casaviewer`, etc. installed. Launch any.
  * Once a day, running `casa` or `casaviewer` will automatically populate `~/.casa/data` with [External Data](https://casadocs.readthedocs.io/en/stable/notebooks/external-data.html).
* The `make` command builds the container with `docker compose` commands, and then starts it and connects you to the container's shell. 
* The container runs in the background - you can safely exit back to host shell with CTRL+D or `exit`.
* You may also kill/stop it with `make stop` in host shell, **but make sure that your (important) data is located inside a mounted volume** (explained in next section).
* Rebooting the host machine will kill/stop the container in the background, but progess **inside mounted volumes** is saved. 
* If you want to reconnect after a CTRL+D, a `make stop`, or a host system reboot, just run `make start` in host shell in this directory.
* You may at some point want to erase the content inside the `~/.casa/data` folder used for External Data (e.g. network error while automatically downloading this data at CASA startup). You can do so easily by running `make cleanexternaldata` in host.

### Comments on paths and volume mounts

* **WARNING:** File and Directory changes outside mounted folders/volumes are temporary, they exist while the container is running and **will be erased after stopping the container!!!**
* **WARNING:** The `./casa` (for user data) and `./dotcasa` (for CASA external data) are folders mounted from this directory (`casa-docker`) in host by default. 
  * <ins>They will be erased if this repository is removed and files are thrown into the recycle bin.<ins/>
  * If you plan to remove this repository for some reason, consider mounting a different folder somewhere else in host to the `/home/${USERNAME}/.casa` directory in container - more info below.
* The `/home/<username> == ~` folder itself inside the container **is not a mounted volume**: directories and loose files there are temporary.
  * **Recommended:** run `casa` from a mounted volume such as `~/casa` (or move to one after running `casa`), as the `task.last` files generated when a task is run in CASA are saved to the current working directory in the container, *which may not be mounted*.
  * CASA logs are safely stored at `./casa/logs`, a subfolder inside the mounted `./casa` folder.

You'll need to use container paths in code/ui to mount new folders.

Volumes are mounted from host to container, see `compose.yml`. Example:

```yaml
    volumes:
    # Base
      -
      -
      -
    # User
      - ${PWD}/dotcasa:/home/${USERNAME}/.casa  # default ~/.casa folder from current dir (casa-docker repo)
      - ${PWD}/casa:/home/${USERNAME}/casa  # default ~/casa folder from current dir (casa-docker repo)
```

This means the `./dotcasa` folder (besides this `README`) lives in `~/.casa` in the container, idem for the casa folder.

**Read the READMEs inside `./casa` and `./dotcasa` for more information on these default folders and how to move them -or subfolders inside them- safely.**

### Comments on installed packages in container
You may want to add additional packages to this docker container. To do so:
* Make a backup Dockerfile
* Edit the default Dockerfile with a text editor
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

* **Save the Dockerfile and run** `make` **again** - the container needs to be re-built.
  * Expect some small delay, as Docker will have to install your new packages into the container.
  * As this step is almost at the end of the Dockerfile, Docker will skip all previous un-edited steps if the container was previously built (setting up the OS, downloading and insalling CASA and its prerequisites, etc.) and only re-do this `RUN` where user packages are installed - no coffee, sorry.
* If something does not work, you may have updated another line or entered the wrong format.
  * Delete the Dockerfile and rename the backup back to `Dockerfile`
  * Try again from start (*Make a backup Dockerfile*)

## LICENSE

MIT - but should check on casa's license!
