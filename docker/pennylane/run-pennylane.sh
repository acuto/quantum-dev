#!/bin/bash

docker run -d --name pennylane-dev -v ${HOME}:/workspace -p 8883:8883 pennylane-dev:23.04 /bin/bash