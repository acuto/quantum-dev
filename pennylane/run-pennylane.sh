#!/bin/bash

docker run -it --name pennylane-dev -v ${HOME}:/opt/notebooks -p 8883:8883 pennylane-dev:20.05 /bin/bash -c "/opt/conda/envs/pennylane/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='0.0.0.0' --port=8883 --no-browser --allow-root"