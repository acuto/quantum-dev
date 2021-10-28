#!/bin/bash

docker run -d --name qsharp-dev -v ${HOME}:/workspace -p 9992:9992 qsharp-dev:21.06 /bin/bash