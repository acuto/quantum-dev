#!/bin/bash

docker run -d --name pytket-dev -v ${HOME}:/workspace -p 8889:8889 pytket-dev:23.04 /bin/bash