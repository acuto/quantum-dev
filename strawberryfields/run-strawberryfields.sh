#!/bin/bash

docker run -it --name strawberryfields-dev -v ${HOME}:/workspace -p 8884:8884 strawberryfields-dev:21.03 /bin/bash