#!/bin/bash

docker run -it --name qiskit-dev -v ${HOME}:/workspace -p 8881:8881 qiskit-dev:21.03 /bin/bash