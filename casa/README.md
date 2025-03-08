# The casa folder

**Mounted volume** $PWD/casa:~/casa

## About

* This is your default folder for CASA raw/science data storage and other files.
* It exists in your host machine in the current directory and it is mounted at `~/casa` in the container.
* Changes to this folder --and any sub-folder-- from either host or container will be saved after stopping the container.
* It is recommended to run casa from this directory in the container or other mounted volumes --**otherwise .last files will be deleted after stopping the container**.
* **Changes, such as new files of any kind, outside mounted folders/volumes will also be erased after stopping the container.**

## The data folder inside casa

* This is where you may **safely store** your raw/science data.
* To move it elsewhere inside a mounted volume or mounting a new one, follow the example given for the logs folder down below.
* You can download new data from host and move it here --or somewhere else inside the parent "casa" folder or other mounted volumes-- as you see fit.
* **Changes, such as new files of any kind, outside mounted folders/volumes will be erased after stopping the container.**

## The logs folder inside casa

* This is where logs are stored by default to prevent them from being deleted when stopping the container, and to avoid logs laying around everywhere.
* If you want to move it elsewhere **inside** the "casa" folder:
    * Exit CASA in container if running
    * Create or move the logs folder in host or container
    * Edit the "logfile" path accordingly (*paths are for container, not host*) in `../dotcasa/config.py` (host) or `~/.casa/config.py` (container)
    * Run `casa` again in container to update the folder where CASA will store its logs
* If you want to move it elsewhere **outside** the "casa" folder:
    * Stop the container with command `make stop` if running
    * Create or move the folder in host
    * Edit the "compose.yml" file and mount the new folder under "-volumes" accordingly (see already mounted folders as example)
        * **Use the proper syntax**
        * You may use $PWD/subpath if the logs folder will be inside the "casa-docker" folder
    * Re-build the container with command `make`
    * Edit the "logfile" path accordingly (*paths are for container, not host*) in `../dotcasa/config.py` (host) or `~/.casa/config.py` (container)
    * Run `casa` again in container to update the folder where CASA will store its logs
