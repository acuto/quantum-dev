#!/bin/bash

docker run -it --name qiskit-dev -v ${HOME}:/opt/notebooks -p 8881:8881 qiskit-dev:20.04.2 /bin/bash -c "/opt/conda/envs/qiskit/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='0.0.0.0' --port=8881 --no-browser --allow-root"