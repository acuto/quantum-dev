#!/bin/bash

docker run -it --name quantum-dev -v ${HOME}:/opt/notebooks -p 8888:8888 quantum-dev:20.10 /bin/bash -c "/opt/conda/bin/jupyter lab --notebook-dir=/opt/notebooks --ip='0.0.0.0' --port=8888 --no-browser --allow-root"