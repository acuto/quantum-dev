#!/bin/bash

docker run -it --name pennylane-dev -v ${HOME}:/workspace -p 8883:8883 pennylane-dev:21.03 /bin/bash