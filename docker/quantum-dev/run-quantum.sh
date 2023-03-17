#!/bin/bash

docker run -d --name quantum-dev -v ${HOME}:/workspace -p 8888:8888 quantum-dev:23.04 /bin/bash