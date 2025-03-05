import time


measurespath = "~/data"  # WARN: keep this in sync with entrypoint.sh, compose.yml

logfile = f"{time.strftime("%Y_%m_%d_%H",time.localtime())}.log"
telemetry_enabled = False
crashreporter_enabled = False
