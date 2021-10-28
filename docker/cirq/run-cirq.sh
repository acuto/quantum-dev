#!/bin/bash

docker run -d --name cirq-dev -v ${HOME}:/workspace -p 8882:8882 cirq-dev:21.10 /bin/bash