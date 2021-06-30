#!/bin/bash

# Build miniconda-quantum base docker image
docker build --no-cache -t miniconda-quantum:21.06 ./miniconda-quantum

# Build qiskit-dev docker image
docker build --no-cache -t qiskit-dev:21.06 ./qiskit

# Build cirq-dev docker image
docker build --no-cache -t cirq-dev:21.06 ./cirq

# Build pennylane-dev docker image
docker build --no-cache -t pennylane-dev:21.06 ./pennylane

# Build strawberryfields-dev docker image
docker build --no-cache -t strawberryfields-dev:21.06 ./strawberryfields

# Build forest-dev docker image
docker build --no-cache -t forest-dev:21.06 ./forest

# Build pytket-dev docker image
docker build --no-cache -t pytket-dev:21.06 ./pytket

# Build ocean-dev docker image
docker build --no-cache -t ocean-dev:21.06 ./ocean

# Build qsharp-dev docker image
docker build --no-cache -t qsharp-dev:21.06 ./qsharp

# Build myqlm-dev docker image
docker build --no-cache -t myqlm-dev:21.06 ./myqlm