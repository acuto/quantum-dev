#!/bin/bash

docker run -it --name cirq-dev -v ${HOME}:/workspace -p 8882:8882 cirq-dev:21.01 /bin/bash