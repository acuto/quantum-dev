#!/bin/bash

docker run -it --name strawberryfields-dev -v ${HOME}:/opt/notebooks -p 8884:8884 strawberryfields-dev:20.12 /bin/bash