#!/bin/bash

docker run -d --name strawberryfields-dev -v ${HOME}:/workspace -p 8884:8884 strawberryfields-dev:23.04 /bin/bash