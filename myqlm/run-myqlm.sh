#!/bin/bash

docker run -it --name myqlm-dev -v ${HOME}:/workspace -p 9993:9993 myqlm-dev:21.01 /bin/bash