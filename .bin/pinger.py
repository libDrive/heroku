import os
import time

import requests

url = os.environ.get("PINGER")
if url:
    if url.endswith("/"):
        url = url[:-1]
    while True:
        time.sleep(int(os.environ.get("PINGER_INTERVAL", 900)))
        requests.get("%s/api/v1/ping" % (url))
