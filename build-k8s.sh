#!/bin/bash

# Build miniconda-quantum base docker image
docker build --no-cache -t miniconda-quantum:20.10 ./miniconda-quantum

# Build qiskit-dev docker image
docker build --no-cache -t qiskit-dev:20.10 ./qiskit

# Build cirq-dev docker image
docker build --no-cache -t cirq-dev:20.10 ./cirq

# Build pennylane-dev docker image
docker build --no-cache -t pennylane-dev:20.10 ./pennylane

# Build strawberryfields-dev docker image
docker build --no-cache -t strawberryfields-dev:20.10 ./strawberryfields

# Build forest-dev docker image
docker build --no-cache -t forest-dev:20.10 ./forest

# Build ocean-dev docker image
docker build --no-cache -t ocean-dev:20.10 ./ocean

# Build myqlm-dev docker image
docker build --no-cache -t myqlm-dev:20.10 ./myqlm