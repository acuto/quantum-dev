#!/bin/bash

docker run -it --name forest-dev -v ${HOME}:/opt/notebooks -p 8887:8887 forest-dev:20.10 /bin/bash -c "/opt/conda/envs/pyquil/bin/jupyter lab --notebook-dir=/opt/notebooks --ip='0.0.0.0' --port=8887 --no-browser --allow-root"