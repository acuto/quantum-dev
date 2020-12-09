#!/bin/bash

docker run -it --name forest-dev -v ${HOME}:/opt/notebooks -p 8887:8887 forest-dev:20.12 /bin/bash