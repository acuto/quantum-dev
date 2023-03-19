#!/bin/bash

# Build miniconda-quantum base docker image
docker build --no-cache -t miniconda-quantum:23.04 ./miniconda-quantum

# Build qiskit-dev docker image
docker build --no-cache -t qiskit-dev:23.04 ./qiskit

# Build cirq-dev docker image
docker build --no-cache -t cirq-dev:23.04 ./cirq

# Build tfq-dev docker image
docker build --no-cache -t tfq-dev:23.04 ./tfq

# Build pennylane-dev docker image
docker build --no-cache -t pennylane-dev:23.04 ./pennylane

# Build strawberryfields-dev docker image
docker build --no-cache -t strawberryfields-dev:23.04 ./strawberryfields

# Build forest-dev docker image
docker build --no-cache -t forest-dev:23.04 ./forest

# Build pytket-dev docker image
docker build --no-cache -t pytket-dev:23.04 ./pytket

# Build ocean-dev docker image
docker build --no-cache -t ocean-dev:23.04 ./ocean

# Build qsharp-dev docker image
docker build --no-cache -t qsharp-dev:23.04 ./qsharp

# Build myqlm-dev docker image
docker build --no-cache -t myqlm-dev:23.04 ./myqlm