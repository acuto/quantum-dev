#!/bin/bash

docker run -it --name cirq-dev -v ${HOME}:/opt/notebooks -p 8882:8882 cirq-dev:20.12 /bin/bash