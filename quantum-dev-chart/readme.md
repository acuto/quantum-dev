# Quantum-Dev Helm Chart

## A development environment for Quantum Computing on Kubernetes

The development environment features the following open-source Quantum Computing frameworks reachable as services on a Kubernetes cluster:

* **IBM Qiskit**
* **Google Cirq and TensorFlow Quantum**
* **Xanadu PennyLane**
* **Rigetti Forest SDK**
* **D-Wave Ocean SDK**


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

Once the deploy is complete, you can access the Jupyter Notebook Web Interface with the convenience script `quantum-dev.sh`

```sh
$ ./quantum-dev.sh quantum-dev qiskit
```

It accepts as parameter the k8s namespace and the quantum computing framework you need.
`quantum-dev` is the namespace choosen as default but it can be changed on the values.yaml file.

The script prints to screen the URL of the Jupyter Notebook web interface of the framework and creates the necessary port forwarding.
In future releases, an Ingress service will expose all the services without need of port forwarding
