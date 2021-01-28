#!/bin/bash

docker run -it --name ocean-dev -v ${HOME}:/workspace -p 9991:9991 ocean-dev:21.01 /bin/bash