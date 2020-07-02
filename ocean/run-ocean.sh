#!/bin/bash

docker run -it --name ocean-dev -v ${HOME}:/opt/notebooks -p 9991:9991 ocean-dev:20.07 /bin/bash -c "/opt/conda/envs/ocean/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='0.0.0.0' --port=9991 --no-browser --allow-root"