#!/bin/bash

docker run -d --name myqlm-dev -v ${HOME}:/workspace -p 9993:9993 myqlm-dev:21.10 /bin/bash