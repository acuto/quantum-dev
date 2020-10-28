#!/bin/bash

docker run -it --name cirq-dev -v ${HOME}:/opt/notebooks -p 8882:8882 cirq-dev:20.10 /bin/bash -c "/opt/conda/envs/cirq/bin/jupyter lab --notebook-dir=/opt/notebooks --ip='0.0.0.0' --port=8882 --no-browser --allow-root"