#!/bin/bash

docker run -d --name ocean-dev -v ${HOME}:/workspace -p 9991:9991 ocean-dev:23.04 /bin/bash