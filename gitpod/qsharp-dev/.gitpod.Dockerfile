FROM gitpod/workspace-base:latest

LABEL name="qsharp-dev"
LABEL description="Development Environment for Microsoft QDK"
LABEL maintainer="Alberto Acuto alberto.acuto@nttdata.com"
LABEL vendor="NTT DATA"

# Set version levels
ENV CONDA_VERSION 22.11.1
ENV JUPYTER_VERSION 1.0.0
ENV JUPYTERLAB_VERSION 3.5.3
ENV PYTHON_VERSION 3.9.16
ENV IPYKERNEL_VERSION 6.19.2

# System packages 
RUN sudo apt-get update && \
    sudo apt-get install --yes gcc

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
COPY requirements.txt .

# Create environment for Microsoft QDK
RUN conda create --name qsharp --yes python=$PYTHON_VERSION ipykernel=$IPYKERNEL_VERSION && \
    conda run --name qsharp pip install -r requirements.txt

# Clean Conda installation
RUN conda clean --yes --all

# Install PGP
RUN sudo apt-get update && \
    sudo apt-get install --yes pgp

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

# Create Jupyter Notebook folder
RUN mkdir /home/gitpod/workspace && cd /home/gitpod/workspace

# Set working directory
WORKDIR /home/gitpod/workspace

# Set prompt
RUN echo "export PS1='🐳 \[\033[1;34m\]\W \[\033[1;36m\]$ \[\033[0m\]'" >> ~/.bashrc

# Expose port for Jupyter Lab web access
EXPOSE 9992

# Define entrypoint
ENTRYPOINT ["/bin/bash", \
            "-c", "/home/gitpod/miniconda3/envs/qsharp/bin/jupyter lab \
            --notebook-dir=/home/gitpod/workspace --ip='0.0.0.0' --port=9992 --no-browser \
            --allow-root --NotebookApp.token='quantum-dev-qsharp'"]