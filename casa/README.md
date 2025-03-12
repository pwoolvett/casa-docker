# The casa folder

**Volume mounted by default in** `compose.yml`:
```yaml
    volumes:
    # Base
      - 
      -
      -
    # User
      -
      - ${PWD}/casa:/home/${USERNAME}/casa  # default ~/casa folder from current dir (casa-docker repo)
```

## About

* This is your default folder for CASA operation: storage of raw/science data and other files such as logs.
* **DATA LOSS WARNING: will be deleted if you remove this repository and move files to recycle bin.**
* It exists in your host machine in the current directory (besides this README) and it is mounted at `/home/${USERNAME}/casa == ~/casa` in the container.
* Changes to this folder -and any subfolder- from either host or container will be saved even after stopping the container.

## The data folder inside casa

* **Created when you build the container, if it does not exist.**
* This is where you may **safely store** your raw/science data.
* You can download new data from host and move it here -or somewhere else inside mounted volumes- as you see fit.

* If you want to move it elsewhere **outside** folders mounted by default (mount your own folder, <ins>**RECOMMENDED** if you want to remove this repository in the future **AND KEEP YOUR DATA**</ins>):
  * Build the container with `make` in host if you haven't already
  * Exit CASA in container if running
  * Exit the container shell and stop it with command `make stop` in host
  * Create or move the data folder in host
  * Edit the `../compose.yml` file and mount the "data" folder from `/path/in/host/data` to `/path/in/container/data` under "-volumes" accordingly (see already mounted folders as example and **use the proper syntax**)
  * Edit Entry 2 in `../entrypoint.sh` in host:
    * Remove the line containing the `mkdir` statement, your raw/science `data` folder already exists and will be mounted following `../compose.yml`.
    * Give the proper `path/in/container/data` to the `chown` command to give the user in container ownership over the folder.
  * Re-build the container with command `make`

* If you want to move it elsewhere **inside** volumes mounted by default - the `../casa` (here) and `../dotcasa` folders:
  * Build the container with `make` in host if you haven't already
  * Exit CASA in container if running
  * Exit the container shell and stop it with command `make stop`
  * Create or move the data folder (`./data`) somewhere inside `../casa` or `../dotcasa` in host (**careful, there is a `data` folder inside `../dotcasa` too**)
  * Your folder will be at the new directory, *no need to mount it as it should be inside a folder mounted by default*
  * Edit Entry 2 in `../entrypoint.sh` in host:
    * Remove the line containing the `mkdir` statement, your raw/science `data` folder already exists inside a volume mounted by default
    * Give the proper `path/in/container/data` to the `chown` command to give the user in container ownership over the folder
  * Re-build the container with command `make`

## The logs folder inside casa

* **Created when you build the container, if it does not exist.**
* This is where logs are stored by default to prevent them from being deleted when stopping the container, and to avoid logs laying around everywhere.

* If you want to move it elsewhere **outside** folders mounted by default (mount your own folder, <ins>**RECOMMENDED** if you want to remove this repository in the future **AND KEEP YOUR LOGS**</ins>):
  * Build the container with `make` in host if you haven't already
  * Exit CASA in container if running
  * Exit the container shell and stop it with command `make stop`
  * Create or move the logs folder in host
  * Edit the `../compose.yml` file and mount the "logs" folder from `/path/in/host/logs` to `/path/in/container/logs` under "-volumes" accordingly (see already mounted folders as example and **use the proper syntax**)
  * Edit Entry 3 in `../entrypoint.sh` in host:
    * Remove the line containing the `mkdir` statement, your `logs` folder already exists and will be mounted following `../compose.yml`.
    * Give the proper `path/in/container/logs` to the `chown` command to give the user in container ownership over the folder.
  * Edit the "logfile" path accordingly (*paths are for container, not host*) in `../dotcasa/config.py`
  * Re-build the container with command `make`
  * Run `casa` again in container to update the folder where CASA will store its logs

* If you want to move it elsewhere **inside** volumes mounted by default - the `../casa` (here) and `../dotcasa` folders:
  * Build the container with `make` in host if you haven't already
  * Exit CASA in container if running
  * Exit the container shell and stop it with command `make stop`
  * Create or move the logs folder (`./logs`) somewhere inside `../casa` or `../dotcasa` in host
  * Your folder will be at the new directory, *no need to mount it as it should be inside a folder mounted by default*
  * Edit Entry 3 in `../entrypoint.sh` in host:
    * Remove the line containing the `mkdir` statement, your `logs` folder already exists inside a volume mounted by default
    * Give the proper `path/in/container/logs` to the `chown` command to give the user in container ownership over the folder.
  * Edit the "logfile" path accordingly (*paths are for container, not host*) in `../dotcasa/config.py`
  * Re-build the container with command `make`
  * Run `casa` again in container to update the folder where CASA will store its logs