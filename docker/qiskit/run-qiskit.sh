#!/bin/bash

docker run -d --name qiskit-dev -v ${HOME}:/workspace -p 8881:8881 qiskit-dev:23.04 /bin/bash