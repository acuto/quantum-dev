# Quantum-Dev

## A multi-framework development environment for Quantum Computing on Kubernetes

### This project implements a quantum development environment, based on Jupyter and featuring the main Python-based Quantum Computing frameworks.

The solution meets the following main requirements:
* **Self-consistency**: all dependencies are fully resolved within an environment deployment
* **Immutability**: all installed components are fully versioned
* **Replicability**: the whole environment can be built ground-up via source code

The project adopts standard "Everything-as-Code" best practices, and delivers the development environment as a Docker container, thus capable to be run on all used platforms (Windows, Mac, Linux). The Docker Hub [`miniconda3`](https://hub.docker.com/r/continuumio/miniconda3/) image is used as the base image.

The development environment features the following open-source Quantum Computing frameworks:

* **IBM Qiskit**
* **Google Cirq and TensorFlow Quantum**
* **Xanadu PennyLane**
* **Xanadu Strawberry Fields**
* **Rigetti Forest SDK**
* **D-Wave Ocean SDK**
* **Atos myQLM**

New releases of this project update the version levels for all installed components, preserving consistency of all dependencies.

---
> **Note**: All included shell scripts are formatted as Bash files (`.sh`) so they can be natively run in a macOS or Linux environment. If using Windows (the most common platform for enterprise workstations) it is sufficient to rename scripts as PowerShell files (`.ps1`) &mdash; the used syntax being invariant. When running on a Windows platform, it is strongly advised to use PowerShell as the native terminal. Another preferred option, if using Windows 10, is to exploit Windows Subsystem for Linux (WSL) as the Docker client, thus relying on Bash as the native terminal syntax. Detailed instructions on how to set this configuration up can be found in `wsl.md`.
---

## Preconditions:

* Windows 10 or macOS (10.13 or newer) workstation with at least 8GB RAM (16GB recommended). Linux host with at least 32GB RAM for the Kubernetes solution.
* Docker installed on host. For Windows or Mac, Docker Desktop installation can be found [here](https://www.docker.com/products/docker-desktop).
* Kubectl installed and configured on host. Installation guide can be found [here](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
* Helm installed on host. Installation guide can be found [here](https://helm.sh/docs/intro/install/).


## Kubernetes setup

The simplest way to set up the development environment in a private or public cloud is to deploy the Kubernetes solution. This creates one pod for each framework, each of them being accessible through the Jupyter Lab web interface (via `kubectl` port forwarding). All frameworks are naturally segregated by the pod structure. The complete Kubernetes stack can be built and executed through the following helper scripts:

```sh
$ cd quantum-dev
$ ./build-k8s.sh
$ ./install-k8s.sh
```

The frameworks are exposed outside the cluster with `NodePort` services. In a local setup environment correctly supporting `NodePort` services (e.g. Kubernetes on Docker Desktop) you can easily reach them at the following URLs:

* **IBM Qiskit**: http://localhost:30881 
* **Google Cirq and TensorFlow Quantum**: http://localhost:30882
* **Xanadu PennyLane**: http://localhost:30883
* **Xanadu Strawberry Fields**: http://localhost:30884
* **Rigetti Forest SDK**: http://localhost:30887
* **D-Wave Ocean SDK**: http://localhost:30991
* **Atos myQLM**: http://localhost:30992

In a private cluster environment, you could do port forwarding of these services before reaching them or, if the cluster is public, simply change `localhost` with your domain name.

In the Kubernetes solution, all services are protected by a password. Default passwords for accessing any quantum framework in Jupyter Lab are in the "`quantum-dev-<framework>`" format, where "`<framework>`" must be replaced by any of "`qiskit`", "`cirq`", "`pennylane`", "`strawberryfields`", "`forest`", "`ocean`" or "`myqlm`" &mdash; e.g. to access the Qiskit framework, the default password is "`quantum-dev-qiskit`". In order to change the default passwords:
- Edit the files at `quantum-dev-chart/secrets/files`.
- Deploy to Kubernetes by launching the `gen-secrets.sh` convenience script.

---
> **Note**: hashed passwords can be prepared in a Jupyter Notebook through the following python commands:
```python
In [1]: from notebook.auth import passwd
In [2]: passwd('<new-password>', algorithm='sha1')
Out [2]: 'sha1:fc0d38552a1a:a13dd5d7673ad3ec727d3e1749abefe0ba570c5a'
```
---

The Kubernetes deployment can be uninstalled by launching the script:

```sh
$ ./uninstall-k8s.sh
```

## All-In-One Docker setup

The simplest way to run the development environment on a workstation is to build the "All-In-One" solution. This creates one Docker container for all frameworks, each of them being accessible through the Jupyter Lab web interface. In order to avoid Python dependency inconsistencies, all frameworks are installed in private and segregated Conda environments.

The Docker images can be built through the following command (more easily, by executing the `build-all.sh` script in the `all-in-one` directory):

```sh
$ cd all-in-one
$ docker build --no-cache -t quantum-dev:20.10 .
```

Once the Docker image is built, the container is ready to be executed (`run-all.sh` script):

```sh
$ docker run -it --name quantum-dev -v ${HOME}:/opt/notebooks -p 8888:8888 quantum-dev:20.10 /bin/bash -c "/opt/conda/bin/jupyter lab --notebook-dir=/opt/notebooks --ip='0.0.0.0' --port=8888 --no-browser --allow-root"
```

The above command enables a volume to share Jupyter Notebooks and any other files between the host and the container &mdash; whose mount point is set to `/opt/notebooks`. The folder shared on the host is by default the home folder: in order to set your own preference, just replace the `${HOME}` statement in the script with the full path to your chosen folder. Use native path syntax when running on Windows, Mac or Linux hosts.

The URL of the Jupyter Notebook web interface can be copied from the command output &mdash; e.g.:

    To access the notebook, open this file in a browser:
        file:///root/.local/share/jupyter/runtime/nbserver-1-open.html
    Or copy and paste one of these URLs:
        http://383b64483798:8888/?token=cbab2e5b7bacd35da5f413c8738742443fa672c4376864fc
     or http://127.0.0.1:8888/?token=cbab2e5b7bacd35da5f413c8738742443fa672c4376864fc

The URL containing the `localhost` IP address (`127.0.0.1`) is usually working flawlessly on any systems, so it's the advised one to pick in practice.

The Jupyter server in the container can be gracefully shut down by typing `CTRL-C`. The `all-in-one` directory also contains useful scripts to delete the container (`rm-all.sh`) and the image (`rmi-all.sh`).

## Framework-specific Docker setup

Instead of assembling one container featuring all quantum frameworks as different Conda environments, it is possible to build separate containers for each framework. This is particularly resource-effective on a development workstation when focusing on a given framework. In the following we shall provide details for building and executing Qiskit &mdash; for the other supported frameworks, simply repeat framework-specific steps in the proper directory.

As a first step, valid for all frameworks, we have to build an intermediate base image &mdash; `miniconda-quantum`, providing framework-independent operations over the base [`continuumio/miniconda3`](https://hub.docker.com/r/continuumio/miniconda3/) image &mdash; through the following command (more easily, by executing the `build-miniconda-quantum.sh` script in the `miniconda-quantum` directory):

```sh
$ cd miniconda-quantum
$ docker build --no-cache -t miniconda-quantum:20.10 .
```

The Qiskit Docker image can be built through the following command (`build-qiskit.sh` script in the `qiskit` directory):

```sh
$ cd qiskit
$ docker build --no-cache -t qiskit-dev:20.10 .
```

Once the Docker image is built, the container is ready to be executed (`run-qiskit.sh` script):

```sh
$ docker run -it --name qiskit-dev -v ${HOME}:/opt/notebooks -p 8881:8881 qiskit-dev:20.10 /bin/bash -c "/opt/conda/envs/qiskit/bin/jupyter lab --notebook-dir=/opt/notebooks --ip='0.0.0.0' --port=8881 --no-browser --allow-root"
```

Again, you can customize the shared folder on your host by replacing the `${HOME}` statement, and the URL or the Jupyter Lab web interface can be copied from the command output &mdash; e.g.:

    To access the notebook, open this file in a browser:
        file:///root/.local/share/jupyter/runtime/nbserver-1-open.html
    Or copy and paste one of these URLs:
        http://b48934b3fb17:8881/?token=db5b7503ffad7300b9a7607be4ea67eb0828ff1c19412f96
     or http://127.0.0.1:8881/?token=db5b7503ffad7300b9a7607be4ea67eb0828ff1c19412f96

As for the `all-in-one` solution, the `qiskit` directory also contains useful scripts to delete the container (`rm-qiskit.sh`) and the image (`rmi-qiskit.sh`).

## Starting Rigetti Forest QVM

The Rigetti Forest SDK includes PyQuil (the Python library), the Rigetti Quil Compiler (quilc &mdash; which allows compilation and optimization of Quil programs to native gate sets), and the Quantum Virtual Machine (QVM &mdash; the open source implementation of a quantum abstract machine on classical hardware, allowing simulations of Quil programs).

Both quilc and QVM need to be started in the active container to run Quil programs in the simulated environment. In order to do that, open another terminal and type command:

```sh
$ docker exec -d quantum-dev bash -c "/start-qvm.sh"
```

if executing the all-in-one solution, or:

```sh
$ docker exec -d forest-dev bash -c "/start-qvm.sh"
```

if running the Forest-specific environment. In both cases, the command can also be issued by executing the `run-qvm.sh` script in the proper directory, and then the new terminal can be safely closed.

## Saving and loading Docker images

Some of the used Python packages (e.g. TensorFlow) are huge in size. Therefore, it may be a good idea to save the built Docker images locally &mdash; especially if expecting to work with low-bandwidth or 4G metered connections. Docker provides simple commands to save a tagged image to a tar file &mdash; e.g.:

```sh
$ docker save -o quantum-dev-20.10.tar quantum-dev:20.10
```

and then reload the image from the tar file:

```sh
$ docker load -i quantum-dev-20.10.tar
```