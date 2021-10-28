#!/bin/bash

docker run -d --name qiskit-dev -v ${HOME}:/workspace -p 8881:8881 qiskit-dev:21.06 /bin/bash