#!/bin/bash

docker run -it --name quantum-dev -v ${HOME}:/opt/notebooks -p 8888:8888 quantum-dev:20.12 /bin/bash