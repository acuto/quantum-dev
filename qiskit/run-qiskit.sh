#!/bin/bash

docker run -it --name qiskit-dev -v ${HOME}:/opt/notebooks -p 8881:8881 qiskit-dev:20.12 /bin/bash