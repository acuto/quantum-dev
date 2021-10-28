#!/bin/bash

docker run -d --name pytket-dev -v ${HOME}:/workspace -p 8889:8889 pytket-dev:21.10 /bin/bash