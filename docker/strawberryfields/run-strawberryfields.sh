#!/bin/bash

docker run -d --name strawberryfields-dev -v ${HOME}:/workspace -p 8885:8885 strawberryfields-dev:23.04 /bin/bash