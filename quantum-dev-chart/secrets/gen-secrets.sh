#!/bin/bash

kubectl kustomize ./ > jupyter-secrets.yaml
sed -i 's#name: jupyter-[a-z0-9]*#name: jupyter#g' jupyter-secrets.yaml
kubectl apply -f jupyter-secrets.yaml
rm -f jupyter-secrets.yaml
