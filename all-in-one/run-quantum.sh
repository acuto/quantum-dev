#!/bin/bash

docker run -it --name quantum-dev -v ${HOME}:/workspace -p 8888:8888 quantum-dev:21.01 /bin/bash