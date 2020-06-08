# Quantum-Dev Helm Chart

## A development environment for Quantum Computing on Kubernetes

The development environment features the following open-source Quantum Computing frameworks reachable as services on a Kubernetes cluster:

* **IBM Qiskit**
* **Google Cirq and TensorFlow Quantum**
* **Xanadu PennyLane**
* **Rigetti Forest SDK**
* **D-Wave Ocean SDK**

Each service is backed by a pod mounting an external volume for persistency.

## Preconditions:

* Windows 10, macOS (10.13 or newer) or Linux host with at least 8GB RAM.
* kubectl installed and configured on host. Installation guide [here](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* helm installed on host. Installation guide [here](https://helm.sh/docs/intro/install/)

## All-In-One setup

The simplest way to set up the environment is to deploy the "All-In-One" solution. This creates one pod for each framework, each of them being accessible through the Jupyter Notebook web interface ( via kubectl port forwarding ). 
All the frameworks are naturally segregated by the pod structure. 

```sh
$ cd quantum-dev
$ helm install quantum-dev ./quantum-dev-chart
```

The frameworks are exposed outside the cluster with NodePort services. In a local setup environment correctly supporting NodePort services ( k8s on docker-desktop for instance ), you can easily reach them at the following URLs:

* **IBM Qiskit** http://localhost:30881 
* **Google Cirq and TensorFlow Quantum** http://localhost:30882
* **Xanadu PennyLane** http://localhost:30883
* **Rigetti Forest SDK** http://localhost:30887
* **D-Wave Ocean SDK** http://localhost:30991

Once there, you can type the password. In order to change the passwords:
- Edit the files at [secrets/files](secrets/files)
- Deploy to k8s by launching the convenience script `gen-secrets.sh`
