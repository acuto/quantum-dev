# Quantum-Dev

## A multi-platform, multi-framework development environment for Quantum Computing

### This project implements a quantum development environment, based on Jupyter Notebook and featuring the main Python-based Quantum Computing frameworks.

The solution meets the following main requirements:
* **Self-consistency**: all dependencies are fully resolved within an environment deployment
* **Immutabilty**: all installed components are fully versioned
* **Replicability**: the whole environment can be built ground-up via source code

The project adopts standard "Everything-as-Code" best practices, and delivers the development environment as a Docker container, thus capable to be run on all used platforms (Windows, Mac, Linux). The Docker Hub [``miniconda3``](https://hub.docker.com/r/continuumio/miniconda3/) image is used as the base image.

The development environment features the following open-source Quantum Computing frameworks:

* **IBM Qiskit**
* **Google Cirq and TensowFlow Quantum**
* **Xanadu PennyLane**
* **D-Wave Ocean**

New releases of this project update the version levels for all installed components, preserving consistency of all dependencies.

## Preconditions:

* Windows 10, macOS (10.13 or newer) or Linux host with at least 8GB RAM.
* Docker installed on host. For Windows or Mac, Docker Desktop installation can be found [here](https://www.docker.com/products/docker-desktop).

For Windows 10 hosts, Hyper-V must be enabled in order to run Docker. The feature can be enabled from an elevated PowerShell prompt, prior to Docker installation:

```powershell
PS> Set-ExecutionPolicy RemoteSigned
PS> Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V –All
```

Consider that once Hyper-V is enabled on a host, any other common hypervisors &mdash; like VMware or VirtualBox &mdash; cannot be run anymore. In order to run them again, you need to disable the Hyper-V feature:

```powershell
PS> Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V –All
```

---
> **Note**: Being Windows the most common platform for enterprise workstations, all included shell scripts are formatted as PowerShell files (``.ps1``). In order to execute scripts in a macOS or Linux environment, it is sufficient to rename them as Bash or Zsh files (``.sh``) &mdash; the used syntax being invariant. If using a Windows platform, it is strongly advised to use PowerShell as the terminal.
---
> **Note**: Docker Desktop relies on a Linux Virtual Machine on Windows and Mac hosts. The size of the VM tends to grow in size with time &mdash; due a faulty estimation of free disk blocks in the Docker/Linux system. If getting low in disk free space, issue a "Reset to factory defaults" on the ``Troubleshoot`` panel in the Docker Desktop application. Also manually deleting the Virtual Disk file when Docker Desktop is not running is considered to be safe &mdash; an empty Virtual Disk is automatically recreated upon Docker Desktop next startup. The location of the Virtual Disk (e.g. ``C:\ProgramData\DockerDesktop\vm-data`` on Windows) can be taken from the ``Settings/Resources`` panel in the Docker Desktop application. Consider that all containers and images will be lost as a result of that operation &mdash; but remember that containers are meant to be volatile by design! If you cannot rely on a local Docker Registry, in order to avoid massive data download when rebuilding images, consider saving your built images (see below "_Saving and loading Docker images_").
---

## All-In-One setup

The simplest way to run the development environment is to build the "All-In-One" solution. This creates one Docker container for all frameworks, each of them being accessible through the Jupyter Notebook web interface. In order to avoid Python dependency inconsistencies, all frameworks are installed in private and segregated Conda environments.

The Docker images can be built through the following command (more easily, by executing the ``build-all`` script in the ``all-in-one`` directory):

```sh
$ cd all-in-one
$ docker build --no-cache -t quantum-dev:20.04.2 .
```

Once the Docker image is built, the container is ready to be executed (``run-all`` script):

```sh
$ docker run -it --name quantum-dev -v ${HOME}:/opt/notebooks -p 8888:8888 quantum-dev:20.04.2 /bin/bash -c "/opt/conda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='0.0.0.0' --port=8888 --no-browser --allow-root"
```

The above command enables a volume to share Jupyter Notebooks and any other files between the host and the container &mdash; whose mount point is set to ``/opt/notebooks``. The folder shared on the host is by default the home folder: in order to set your own preference, just replace the ``${HOME}`` statement in the script with the full path to your chosen folder. Use native path syntax when running on Windows, Mac or Linux hosts.

The URL of the Jupyter Notebook web interface can be copied from the command output &mdash; e.g.:

    To access the notebook, open this file in a browser:
        file:///root/.local/share/jupyter/runtime/nbserver-1-open.html
    Or copy and paste one of these URLs:
        http://383b64483798:8888/?token=cbab2e5b7bacd35da5f413c8738742443fa672c4376864fc
     or http://127.0.0.1:8888/?token=cbab2e5b7bacd35da5f413c8738742443fa672c4376864fc

The Jupyter server in the container can be gracefully shut down by typing ``CTRL-C``. The ``all-in-one`` directory also contains userful scripts to delete the container (``rm-all``) and the image (``rmi-all``).

## Framework-specific setup

Instead of assembling one container featuring all quantum frameworks as different Conda environments, it is possible to build separate containers for each framework. This proves effective when focusing on a given framework. In the following we shall provide details for building and executing Qiskit &mdash; for the other supported frameworks, simply repeat framwework-specific steps in the proper directory.

As a first step, valid for all frameworks, we have to build an intermediate base image &mdash; ``miniconda-quantum``, providing framework-independent operations over the base [``continuumio/miniconda3``](https://hub.docker.com/r/continuumio/miniconda3/) image &mdash; through the following command (more easily, by executing the ``build-miniconda-quantum`` script in the ``miniconda-quantum`` directory):

```sh
$ cd miniconda-quantum
$ docker build --no-cache -t miniconda-quantum:20.04.2 .
```

The Qiskit Docker image can be built through the following command (``build-qiskit`` script in the ``qiskit`` directory):

```sh
$ cd qiskit
$ docker build --no-cache -t qiskit-dev:20.04.2 .
```

Once the Docker image is built, the container is ready to be executed (``run-qiskit`` script):

```sh
$ docker run -it --name qiskit-dev -v ${HOME}:/opt/notebooks -p 8881:8881 qiskit-dev:20.04.2 /bin/bash -c "/opt/conda/envs/qiskit/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='0.0.0.0' --port=8881 --no-browser --allow-root"
```

Again, you can customize the shared folder on your host by replacing the ``${HOME}`` statement, and the URL or the Jupyter Notebook web interface can be copied from the command output &mdash; e.g.:

    To access the notebook, open this file in a browser:
        file:///root/.local/share/jupyter/runtime/nbserver-1-open.html
    Or copy and paste one of these URLs:
        http://b48934b3fb17:8881/?token=db5b7503ffad7300b9a7607be4ea67eb0828ff1c19412f96
     or http://127.0.0.1:8881/?token=db5b7503ffad7300b9a7607be4ea67eb0828ff1c19412f96

As for the ``all-in-one`` solution, the ``qiskit`` directory also contains userful scripts to delete the container (``rm-qiskit``) and the image (``rmi-qiskit``).

## Saving and loading Docker images

Some of the used Python packages (e.g. TensorFlow) are huge in size. Therefore, it may be a good idea to save the built Docker images locally &mdash; especially if expecting to work with low-bandwidth or 4G metered connections. Docker provides simple commands to save a tagged image to a tar file &mdash; e.g.:

```sh
$ docker save -o quantum-dev-20.04.2.tar quantum-dev:20.04.2
```

and then reload the image from the tar file:

```sh
$ docker load -i quantum-dev-20.04.2.tar
```