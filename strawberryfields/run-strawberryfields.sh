#!/bin/bash

docker run -it --name strawberryfields-dev -v ${HOME}:/opt/notebooks -p 8884:8884 strawberryfields-dev:20.10 /bin/bash -c "/opt/conda/envs/strawberryfields/bin/jupyter lab --notebook-dir=/opt/notebooks --ip='0.0.0.0' --port=8884 --no-browser --allow-root"