# The dotcasa (host) or .casa (container) folder

**Mounted volume** $PWD/dotcasa:~/.casa

## About

* This is the usual ~/.casa folder **managed by CASA itself**.
* Also contains the config.py file to configure some CASA runtime options, such as path to save logs.

## The config.py file

See the [casaconfig site](https://casadocs.readthedocs.io/en/stable/api/casaconfig.html) as an example of the runtime options that can be set here.


## The data folder inside dotcasa

* **Created when you build the container, if it does not exist.**.
* The [External data](https://casadocs.readthedocs.io/en/stable/notebooks/external-data.html) necessary for proper CASA operation is stored here. 
* This folder is managed automatically by CASA, and is updated on a daily basis if `casa` or `casaviewer` are run.
