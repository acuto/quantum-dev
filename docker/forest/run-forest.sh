#!/bin/bash

docker run -d --name forest-dev -v ${HOME}:/workspace -p 8887:8887 forest-dev:23.04 /bin/bash