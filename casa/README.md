# The casa folder

**Mounted volume** $PWD/casa:~/casa

## About

* This is your default folder for CASA raw/science data storage and other files.
* It exists in your host machine in the current directory and it is mounted at `~/casa` in the container.
* Changes to this folder -and any subfolder- from either host or container will be saved after stopping the container.
* It is recommended to run casa from this directory (or other mounted volume) in the container, **otherwise .last files will be deleted after stopping the container**.
* **Changes, such as new files of any kind, outside mounted folders/volumes will also be erased after stopping the container.**

## The data folder inside casa

* **Created when you build the container, if it does not exist.**
* This is where you may **safely store** your raw/science data.
* To move it elsewhere inside a mounted volume or mounting a new one, follow the example given for the logs folder down below.
* You can download new data from host and move it here -or somewhere else inside mounted volumes- as you see fit.
* **Changes, such as new files of any kind, outside mounted folders/volumes will be erased after stopping the container.**

## The logs folder inside casa

* **Created when you build the container, if it does not exist.**
* This is where logs are stored by default to prevent them from being deleted when stopping the container, and to avoid logs laying around everywhere.
* If you want to move it elsewhere **inside** the "casa" folder (or move it to "dotcasa" for some reason):
    * Exit CASA in container if running
    * Exit the container shell and stop it with command `make stop`
    * Create or move the logs folder in host
    * Edit `../entrypoint.sh` in host and remove Entry 3, which creates the casa/logs folder automatically when building the container.
    * Edit the "logfile" path accordingly (*paths are for container, not host*) in `../dotcasa/config.py`
    * Re-build the container with command `make`
    * Run `casa` again in container to update the folder where CASA will store its logs
    
* If you want to move it elsewhere **outside** the "casa" (or dotcasa) folder:
    * Exit CASA in container if running
    * Exit the container shell and stop it with command `make stop`
    * Create or move the logs folder in host
    * Edit `../entrypoint.sh` in host and remove Entry 3, which creates the casa/logs folder automatically when building the container.
    * Edit the "compose.yml" file and mount the new folder under "-volumes" accordingly (see already mounted folders as example)
        * **Use the proper syntax**
        * You may use $PWD/subpath if the logs folder will be inside the "casa-docker" folder
    * Edit the "logfile" path accordingly (*paths are for container, not host*) in `../dotcasa/config.py`
    * Re-build the container with command `make`
    * Run `casa` again in container to update the folder where CASA will store its logs
