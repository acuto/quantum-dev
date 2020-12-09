#!/bin/bash

docker run -it --name pennylane-dev -v ${HOME}:/opt/notebooks -p 8883:8883 pennylane-dev:20.12 /bin/bash