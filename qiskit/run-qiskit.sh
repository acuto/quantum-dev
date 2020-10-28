#!/bin/bash

docker run -it --name qiskit-dev -v ${HOME}:/opt/notebooks -p 8881:8881 qiskit-dev:20.10 /bin/bash -c "/opt/conda/envs/qiskit/bin/jupyter lab --notebook-dir=/opt/notebooks --ip='0.0.0.0' --port=8881 --no-browser --allow-root"