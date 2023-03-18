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
* **CQC t|ket>**
* **D-Wave Ocean SDK**
* **Microsoft QDK**
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

## All-In-One Docker setup

The simplest way to run the development environment on a workstation is to build the "All-In-One" solution. This creates one Docker container for all frameworks, each of them being accessible through the Jupyter Lab web interface. In order to avoid Python dependency inconsistencies, all frameworks are installed in private and segregated Conda environments.

The Docker images can be built through the following command (more easily, by executing the `build-quantum.sh` script in the `docker/quantum-dev` directory):

```sh
$ cd ./docker/quantum-dev
$ docker build --no-cache -t quantum-dev:23.04 .
```

Once the Docker image is built, the container is ready to be executed (`run-quantum.sh` script):

```sh
$ docker run -d --name quantum-dev -v ${HOME}:/workspace -p 8888:8888 quantum-dev:23.04 /bin/bash -c "/opt/conda/bin/jupyter lab --notebook-dir=/workspace --ip='0.0.0.0' --port=8888 --no-browser --allow-root --NotebookApp.token='quantum-dev'"
```

The above command enables a volume to share Jupyter Notebooks and any other files between the host and the container &mdash; whose mount point is set to `/workspace`. The folder shared on the host is by default the home folder: in order to set your own preference, just replace the `${HOME}` statement in the script with the full path to your chosen folder. Use native path syntax when running on Windows, Mac or Linux hosts.

The resulting URL of the Jupyter Notebook web interface is:

http://127.0.0.1:8888/?token=quantum-dev

The Jupyter server in the container can be gracefully shut down by typing `CTRL-C`. The `quantum-dev` directory also contains useful scripts to delete the container (`rm-quantum.sh`) and the image (`rmi-quantum.sh`).

---
> **Note**: when opening a terminal in the docker workspace, keep in mind to activate the required framework environment before using it, e.g.
```sh
$ docker exec -it quantum-dev /bin/bash
🐳 workspace $ conda activate pennylane
(pennylane) 🐳 workspace $
```
---

## Framework-specific Docker setup

Instead of assembling one container featuring all quantum frameworks as different Conda environments, it is possible to build separate containers for each framework. This is particularly resource-effective on a development workstation when focusing on a given framework. In the following we shall provide details for building and executing Qiskit &mdash; for the other supported frameworks, simply repeat framework-specific steps in the proper directory.

As a first step, valid for all frameworks, we have to build an intermediate base image &mdash; `miniconda-quantum`, providing framework-independent operations over the base [`continuumio/miniconda3`](https://hub.docker.com/r/continuumio/miniconda3/) image &mdash; through the following command (more easily, by executing the `build-miniconda-quantum.sh` script in the `docker/miniconda-quantum` directory):

```sh
$ cd ./docker/miniconda-quantum
$ docker build --no-cache -t miniconda-quantum:23.04 .
```

As an example, the Qiskit Docker image can be built through the following command (`build-qiskit.sh` script in the `docker/qiskit` directory):

```sh
$ cd ../qiskit
$ docker build --no-cache -t qiskit-dev:23.04 .
```

Once the Docker image is built, the container is ready to be executed (`run-qiskit.sh` script):

```sh
$ docker run -d --name qiskit-dev -v ${HOME}:/workspace -p 8881:8881 qiskit-dev:23.04 /bin/bash -c "/opt/conda/envs/qiskit/bin/jupyter lab --notebook-dir=/workspace --ip='0.0.0.0' --port=8881 --no-browser --allow-root --NotebookApp.token='quantum-dev-qiskit'"
```

Again, you can customize the shared folder on your host by replacing the `${HOME}` statement.

The default URL of the Jupyter Lab web interfaces are:

* **IBM Qiskit**: http://127.0.0.1:8881/?token=quantum-dev-qiskit 
* **Google Cirq and TensorFlow Quantum**: http://127.0.0.1:8882/?token=quantum-dev-cirq
* **Xanadu PennyLane**: http://127.0.0.1:8883/?token=quantum-dev-pennylane
* **Xanadu Strawberry Fields**: http://127.0.0.1:8884/?token=quantum-dev-strawberryfields
* **Rigetti Forest SDK**: http://127.0.0.1:8887/?token=quantum-dev-forest
* **CQC t|ket>**: http://127.0.0.1:8889/?token=quantum-dev-pytket
* **D-Wave Ocean SDK**: http://127.0.0.1:9991/?token=quantum-dev-ocean
* **Microsoft QDK**: http://127.0.0.1:9992/?token=quantum-dev-qsharp
* **Atos myQLM**: http://127.0.0.1:9993/?token=quantum-dev-myqlm

As for the `All-In-One` solution, the framework-specific directories also contains useful scripts to delete the container (e.g. `rm-qiskit.sh`) and the image (e.g. `rmi-qiskit.sh`).

---
> **Note**: when opening a terminal in the docker workspace, keep in mind to activate the framework environment before using it:
```sh
$ docker exec -it quantum-dev /bin/bash
🐳 workspace $ conda activate qiskit
(qiskit) 🐳 workspace $
```
---

## Starting Rigetti Forest QVM

The Rigetti Forest SDK includes PyQuil (the Python library), the Rigetti Quil Compiler (quilc &mdash; which allows compilation and optimization of Quil programs to native gate sets), and the Quantum Virtual Machine (QVM &mdash; the open source implementation of a quantum abstract machine on classical hardware, allowing simulations of Quil programs).

Both quilc and QVM need to be started in the active container to run Quil programs in the simulated environment. In order to do that, open another terminal and type command:

```sh
$ docker exec -d quantum-dev bash -c "/start-qvm.sh"
```

if executing the `All-In-One` solution, or:

```sh
$ docker exec -d forest-dev bash -c "/start-qvm.sh"
```

if running the Forest-specific environment. In both cases, the command can also be issued by executing the `run-qvm.sh` script in the proper directory, and then the new terminal can be safely closed.

## Integration with Visual Studio Code

[`Visual Studio Code Remote Development`](https://code.visualstudio.com/docs/remote/remote-overview) allows you to use a container as a full-featured development environment. The benefit for Quantum-Dev lies in using its immutable, ready-to-use, and possibly remoted workspaces as attached to a powerful and general-purpose Integrated Development Environment (IDE).

VS Code provides two methods to achieve that. The first consists in [`Attaching to a running container`](https://code.visualstudio.com/docs/remote/attach-container). To accompish this, first start the chosen container as normally done when accessing through the Jupyter Lab web interface. From the VS Code Command Palette (`F1`) select command `"Remote-Containers: Attach to Running Container"` and choose the running container from the drop-down list. This opens a new VS Code instance attached to the container. Note that VS Code will inject its server-side components into the container, and you will also need to install the relevant VS Code extensions within the container as well, e.g.

* `ms-python.python`
* `ms-toolsai.jupyter` (automatically installed by Python)

and, when using Qiskit,

* `qiskit.qiskit-vscode`

All such operations are necessary only when attaching to the container for the first time, since VS Code will keep track of them at a later access. When opening your notebooks, also please mind to select the right Python Kernel for their execution.

A second method to attach to a container as your workspace is to use the VS Code native features for [`Development Containers`](https://code.visualstudio.com/docs/remote/create-dev-container). Though allowing for less flexibility, the advantage is that the above manual operations are automated, if VS Code is the only IDE you are going to use. All you need to do is to copy the right `.devcontainer` and `.vscode` folders in your local workspace (the templates are available in the `vscode` directory of this project). As it can be seen, the `devcontainer.json` file contains all configurations to allow VS Code to run the relevant Docker image properly, e.g.

```json
{
  "name": "qiskit-dev",
  "image": "qiskit-dev:23.04",
  "runArgs": ["-it"],
  "forwardPorts": [8881],
  "extensions": [
    "ms-python.python",
    "ms-toolsai.jupyter",
    "qiskit.qiskit-vscode"
  ],
  "workspaceFolder": "/workspace",
  "workspaceMount": "source=${localWorkspaceFolder},target=/workspace,type=bind,consistency=cached"
}
```

Simply opening with VS Code the folder containing the proper `.devcontainer/devcontainer.json` will start the container, configure it at attach it to the VS Code IDE. In addition, for framework-specific setups, the configuration in `.vscode/settings.json` will automatically select the right Python kernel.

## Using with Gitpod

[Gitpod](https://www.gitpod.io/) is a container-based development platform that provisions ready-to-code developer environments in the cloud, accessible as SaaS through a browser or a local IDE. Gitpod is the quickest and most convenient way to use `Quantum-Dev`, provided you use [GitHub](https://github.com/) or [GitLab](https://about.gitlab.com/) as platforms for your quantum code repos. Gitpod offers various subscription plans, including a free-tier. Being it an Open Source product, it can also be freely self-hosted, and attached to private Git provider.

In order to run your quantum code repo &mdash; say ``https://github.com/<github_username>/my-quantum-dev`` &mdash; in the proper execution environment (e.g. Qiskit) all you need to do is to:

* Add all files included in the related `gitpod` folder (e.g. `gitpod/qiskit-dev`). Adding files in the `gitpod/quantum-dev` folder will create a larger development environment supporting all frameworks (see below [All-In-One Docker setup](#all-in-one-docker-setup)).
* Provide the Gitpod permissions to your Git provider (GitHub in this case).
* Open your development environment with a browser using the URL:

```
https://gitpod.io/#https://github.com/<github_username>/my-quantum-dev
```

## Kubernetes setup

The simplest way to set up the development environment in a private or public cloud is to deploy the Kubernetes solution. This creates one pod for each framework, each of them being accessible through the Jupyter Lab web interface (via `kubectl` port forwarding). All frameworks are naturally segregated by the pod structure. The complete Kubernetes stack can be built and executed through the following helper scripts:

```sh
$ cd docker
$ ./build-all.sh
$ cd ../kubernetes
$ ./install-k8s.sh
```

The frameworks are exposed outside the cluster with `NodePort` services. In a local setup environment correctly supporting `NodePort` services (e.g. Kubernetes on Docker Desktop) you can easily reach them at the following URLs:

* **IBM Qiskit**: http://localhost:30881 
* **Google Cirq and TensorFlow Quantum**: http://localhost:30882
* **Xanadu PennyLane**: http://localhost:30883
* **Xanadu Strawberry Fields**: http://localhost:30884
* **Rigetti Forest SDK**: http://localhost:30887
* **CQC t|ket>**: http://localhost:30889
* **D-Wave Ocean SDK**: http://localhost:30991
* **Microsoft QDK**: http://localhost:30992
* **Atos myQLM**: http://localhost:30993

In a private cluster environment, you could do port forwarding of these services before reaching them or, if the cluster is public, simply change `localhost` with your domain name.

In the Kubernetes solution, all services are protected by a password. Default passwords for accessing any quantum framework in Jupyter Lab are in the "`quantum-dev-<framework>`" format, where "`<framework>`" must be replaced by any of "`qiskit`", "`cirq`", "`pennylane`", "`strawberryfields`", "`forest`", "`pytket`", "`ocean`", "`qsharp`" or "`myqlm`" &mdash; e.g. to access the Qiskit framework, the default password is "`quantum-dev-qiskit`". In order to change the default passwords:
- Edit the files in `kubernetes/quantum-dev-chart/secrets/files`.
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

## Saving and loading Docker images

Some of the used Python packages (e.g. TensorFlow) are huge in size. Therefore, it may be a good idea to save the built Docker images locally &mdash; especially if expecting to work with low-bandwidth or 4G metered connections. Docker provides simple commands to save a tagged image to a tar file &mdash; e.g.:

```sh
$ docker save -o quantum-dev-23.04.tar quantum-dev:23.04
```

and then reload the image from the tar file:

```sh
$ docker load -i quantum-dev-23.04.tar
```