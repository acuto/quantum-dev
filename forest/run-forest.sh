#!/bin/bash

docker run -it --name forest-dev -v ${HOME}:/opt/notebooks -p 8887:8887 forest-dev:20.05 /bin/bash -c "/opt/conda/envs/pyquil/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='0.0.0.0' --port=8887 --no-browser --allow-root"