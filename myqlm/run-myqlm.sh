#!/bin/bash

docker run -it --name myqlm-dev -v ${HOME}:/opt/notebooks -p 9992:9992 myqlm-dev:20.12 /bin/bash