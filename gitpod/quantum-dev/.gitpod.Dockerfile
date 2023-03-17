FROM gitpod/workspace-base:latest

LABEL name="quantum-dev"
LABEL description="Quantum Computing Development Environment"
LABEL maintainer="Alberto Acuto alberto.acuto@nttdata.com"
LABEL vendor="NTT DATA"

# Set version levels
ENV CONDA_VERSION 22.11.1
ENV JUPYTER_VERSION 1.0.0
ENV JUPYTERLAB_VERSION 3.5.3
ENV PYTHON_VERSION 3.9.16
ENV PYTHON_MYQLM_VERSION 3.6.12
ENV IPYKERNEL_VERSION 5.3.4
ENV FOREST_SDK_VERSION 2.23.0

# Install additional packages
RUN sudo apt-get update && \
    sudo apt-get install --yes pgp libmagickwand-dev gcc

# Install Miniconda
RUN wget http://repo.continuum.io/miniconda/Miniconda3-py37_${CONDA_VERSION}-Linux-x86_64.sh && \
    bash Miniconda3-py37_${CONDA_VERSION}-Linux-x86_64.sh -b && \
    rm Miniconda3-py37_${CONDA_VERSION}-Linux-x86_64.sh
ENV PATH=/home/gitpod/miniconda3/bin:${PATH}

# Update Conda
RUN conda install --yes conda=$CONDA_VERSION

# Install Jupyter
RUN conda install --yes --quiet jupyter=$JUPYTER_VERSION jupyterlab=$JUPYTERLAB_VERSION

# Copy Python requirements
COPY requirements_qiskit.txt \
     requirements_cirq.txt \
     requirements_pennylane.txt \
     requirements_strawberryfields.txt \
     requirements_forest.txt \
     requirements_pytket.txt \
     requirements_ocean.txt \
     requirements_qsharp.txt \
     requirements_myqlm.txt ./

# Create environment for IBM Qiskit
RUN conda create --name qiskit --yes python=$PYTHON_VERSION ipykernel=$IPYKERNEL_VERSION && \
    conda run --name qiskit pip install -r requirements_qiskit.txt && \
    conda run --name qiskit python -m ipykernel install --user --name qiskit --display-name "Qiskit"

# Create environment for Google Cirq and Tensorflow Quantum
RUN conda create --name cirq --yes python=$PYTHON_VERSION ipykernel=$IPYKERNEL_VERSION && \
    conda run --name cirq pip install -r requirements_cirq.txt && \
    conda run --name cirq python -m ipykernel install --user --name cirq --display-name "Cirq"

# Create environment for Xanadu PennyLane
RUN conda create --name pennylane --yes python=$PYTHON_VERSION ipykernel=$IPYKERNEL_VERSION && \
    conda run --name pennylane pip install -r requirements_pennylane.txt && \
    conda run --name pennylane python -m ipykernel install --user --name pennylane --display-name "PennyLane"

# Create environment for Xanadu Strawberry Fields
RUN conda create --name strawberryfields --yes python=$PYTHON_VERSION ipykernel=$IPYKERNEL_VERSION && \
    conda run --name strawberryfields pip install -r requirements_strawberryfields.txt && \
    conda run --name strawberryfields python -m ipykernel install --user --name strawberryfields --display-name "Strawberry Fields"

# Create environment for Rigetti Forest SDK
RUN conda create --name pyquil --yes python=$PYTHON_VERSION ipykernel=$IPYKERNEL_VERSION && \
    conda run --name pyquil pip install -r requirements_forest.txt && \
    conda run --name pyquil python -m ipykernel install --user --name pyquil --display-name "PyQuil"

# Install Rigetti Forest SDK
RUN wget http://downloads.rigetti.com/qcs-sdk/forest-sdk-${FOREST_SDK_VERSION}-linux-deb.tar.bz2 && \
    tar -xf ./forest-sdk-${FOREST_SDK_VERSION}-linux-deb.tar.bz2 && \
    sudo apt-get install --yes liblapack-dev libblas-dev libffi-dev libzmq3-dev && \
    sudo ./forest-sdk-${FOREST_SDK_VERSION}-linux-deb/forest-sdk-${FOREST_SDK_VERSION}-linux-deb.run --quiet --accept --noprogress && \
    rm -Rf ./forest-sdk-${FOREST_SDK_VERSION}-linux-deb && \
    rm ./forest-sdk-${FOREST_SDK_VERSION}-linux-deb.tar.bz2
COPY start-qvm.sh ~

# Create environment for CQC t|ket>
RUN conda create --name pytket --yes python=$PYTHON_VERSION ipykernel=$IPYKERNEL_VERSION && \
    conda run --name pytket pip install -r requirements_pytket.txt && \
    conda run --name pytket python -m ipykernel install --user --name pytket --display-name "Pytket"

# Create environment for D-Wave Ocean
RUN conda create --name ocean --yes python=$PYTHON_VERSION ipykernel=$IPYKERNEL_VERSION && \
    conda run --name ocean pip install -r requirements_ocean.txt && \
    conda run --name ocean python -m ipykernel install --user --name ocean --display-name "Ocean"

# Create environment for Microsoft QDK
RUN conda create --name qsharp --yes python=$PYTHON_VERSION ipykernel=$IPYKERNEL_VERSION && \
    conda run --name qsharp pip install -r requirements_qsharp.txt

# Install .NET Core SDK
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg && \
    sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ && \
    wget -q https://packages.microsoft.com/config/debian/10/prod.list && \
    sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list && \
    sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
    sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list && \
    sudo apt-get -y update && \
    sudo apt-get -y install dotnet-sdk-3.1

# Istall IQ# kernel
RUN dotnet tool install -g Microsoft.Quantum.IQSharp && \
    export PATH="/home/gitpod/.dotnet/tools:$PATH" && \
    dotnet-iqsharp install --user --path-to-tool="$(which dotnet-iqsharp)"

# Create environment for Atos myQLM
RUN conda create --name myqlm --yes python=$PYTHON_MYQLM_VERSION ipykernel=$IPYKERNEL_VERSION && \
    conda run --name myqlm pip install -r requirements_myqlm.txt && \
    conda run --name myqlm python -m qat.magics.install && \
    conda run --name myqlm python -m ipykernel install --user --name myqlm --display-name "myQLM"

# Clean Conda installation
RUN conda clean --yes --all

# Create Jupyter Notebook folder
RUN mkdir /home/gitpod/workspace && cd /home/gitpod/workspace

# Set working directory
WORKDIR /home/gitpod/workspace

# Set prompt
RUN echo "export PS1='🐳 \[\033[1;34m\]\W \[\033[1;36m\]$ \[\033[0m\]'" >> ~/.bashrc

# Expose port for Jupyter Lab web access
EXPOSE 8888

# Define entrypoint
ENTRYPOINT ["/bin/bash", \
            "-c", "/home/gitpod/miniconda3/bin/jupyter lab \
            --notebook-dir=/home/gitpod/workspace --ip='0.0.0.0' --port=8888 --no-browser \
            --allow-root --NotebookApp.token='quantum-dev'"]