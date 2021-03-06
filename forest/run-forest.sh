#!/bin/bash

docker run -it --name forest-dev -v ${HOME}:/workspace -p 8887:8887 forest-dev:21.03 /bin/bash