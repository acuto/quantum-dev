#!/bin/bash

docker run -it --name qsharp-dev -v ${HOME}:/workspace -p 9992:9992 qsharp-dev:21.01 /bin/bash