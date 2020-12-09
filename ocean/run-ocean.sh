#!/bin/bash

docker run -it --name ocean-dev -v ${HOME}:/opt/notebooks -p 9991:9991 ocean-dev:20.12 /bin/bash