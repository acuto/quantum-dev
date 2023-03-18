#!/bin/bash

docker run -d --name pennylane-dev -v ${HOME}:/workspace -p 8884:8884 pennylane-dev:23.04 /bin/bash