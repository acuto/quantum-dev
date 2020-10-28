#!/bin/bash

docker run -it --name myqlm-dev -v ${HOME}:/opt/notebooks -p 9992:9992 myqlm-dev:20.10 /bin/bash -c "/opt/conda/envs/myqlm/bin/jupyter lab --notebook-dir=/opt/notebooks --ip='0.0.0.0' --port=9992 --no-browser --allow-root"