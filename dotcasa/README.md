# The dotcasa (host) or .casa (container) folder

**Volume mounted by default in** `compose.yml`:
```yaml
    volumes:
    # Base
      - 
      -
      -
    # User
      - ${PWD}/dotcasa:/home/${USERNAME}/.casa  # default ~/.casa folder from current dir (casa-docker repo)
      -
```

## About

* This is the usual `~/.casa` folder inside the container, which **is managed by CASA itself**.
* Also contains the `config.py` file to configure some CASA runtime options, such as path to save logs.
* Changes to this folder -and any subfolder- from either host or container will be saved even after stopping the container.
* You should have <ins>no need</ins> to change the path in host from which to mount this folder - you will not "lose" your science data if this folder is deleted or corrupted.
* If you want to move it anyways, follow the steps suggested for moving default folders in `../casa/README.md` **BUT**:
  * `../compose.yml`: edit new host path from which to mount `/home/${USERNAME}/.casa` in container, instead of creating a new mounted volume.
  * `../entrypoint.sh`: Only modify if you are also moving the `~/.casa` folder in the container (<ins>not recommended</ins>). 
    * If you want to do it anyways:
      * Change the `TARGET_DIR` variable in Entry 1 to the new path for External data: `/path/in/container/.casa/data`. This creates the new folder for External data inside the new `.casa/` directory inside the container and gives the user ownership over it.
      * Be sure to also configure the new `measurespath` variable (*path in container*) in `./config.py` for the `.casa/data` External data folder (same as `TARGET_DIR` in `../entrypoint.sh`)
  * always end with re-building the container via `make`.
    
## The config.py file

See the [casaconfig site](https://casadocs.readthedocs.io/en/stable/api/casaconfig.html) as an example of the runtime options that can be set here.


## The data folder inside dotcasa

* **Created when you build the container (`../entrypoint.sh`), if it does not exist.**
* The [External data](https://casadocs.readthedocs.io/en/stable/notebooks/external-data.html) necessary for proper CASA operation is stored here. 
* This folder is managed automatically by CASA, and is updated on a daily basis if `casa` or `casaviewer` are run.
