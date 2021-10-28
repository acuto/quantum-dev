#!/bin/bash

quilc --quiet -R &> /var/log/quilc.log &
qvm --quiet -S &> /var/log/qvm.log &