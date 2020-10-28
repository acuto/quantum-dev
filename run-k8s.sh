#!/bin/bash

# Install the quantum-dev chart archive
helm install quantum-dev ./quantum-dev-chart

# Apply jupyter secrets
kubectl kustomize ./quantum-dev-chart/secrets > jupyter-secrets.yaml
sed -i 's#name: jupyter-[a-z0-9]*#name: jupyter#g' jupyter-secrets.yaml
kubectl apply -f jupyter-secrets.yaml
rm -f jupyter-secrets.yaml