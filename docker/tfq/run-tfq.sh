#!/bin/bash

docker run -d --name tfq-dev -v ${HOME}:/workspace -p 8883:8883 tfq-dev:23.04 /bin/bash