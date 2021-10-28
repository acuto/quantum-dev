FROM gitpod/workspace-base:latest

LABEL name="forest-dev"
LABEL description="Development Environment for Rigetti Forest SDK"
LABEL maintainer="Alberto Acuto alberto.acuto@nttdata.com"
LABEL vendor="NTT DATA"

# Set version levels
ENV CONDA_VERSION 4.10.3
ENV JUPYTER_VERSION 1.0.0
ENV JUPYTERLAB_VERSION 3.0.14
ENV PYTHON_VERSION 3.8.8
ENV IPYKERNEL_VERSION 5.3.4
ENV FOREST_SDK_VERSION 2.23.0

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

# Create environment for Rigetti Forest SDK
RUN conda create --name pyquil --yes python=$PYTHON_VERSION ipykernel=$IPYKERNEL_VERSION && \
    conda run --name pyquil pip install -r requirements.txt && \
    conda run --name pyquil python -m ipykernel install --user --name pyquil --display-name "PyQuil"

# Clean Conda installation
RUN conda clean --yes --all

# Install Rigetti Forest SDK
RUN wget http://downloads.rigetti.com/qcs-sdk/forest-sdk-${FOREST_SDK_VERSION}-linux-deb.tar.bz2 && \
    tar -xf ./forest-sdk-${FOREST_SDK_VERSION}-linux-deb.tar.bz2 && \
    sudo apt-get install --yes liblapack-dev libblas-dev libffi-dev libzmq3-dev && \
    sudo ./forest-sdk-${FOREST_SDK_VERSION}-linux-deb/forest-sdk-${FOREST_SDK_VERSION}-linux-deb.run --quiet --accept --noprogress && \
    rm -Rf ./forest-sdk-${FOREST_SDK_VERSION}-linux-deb && \
    rm ./forest-sdk-${FOREST_SDK_VERSION}-linux-deb.tar.bz2
COPY start-qvm.sh ~

# Create Jupyter Notebook folder
RUN mkdir /home/gitpod/workspace && cd /home/gitpod/workspace

# Set working directory
WORKDIR /home/gitpod/workspace

# Set prompt
RUN echo "export PS1='🐳 \[\033[1;34m\]\W \[\033[1;36m\]$ \[\033[0m\]'" >> ~/.bashrc

# Expose port for Jupyter Lab web access
EXPOSE 8887

# Define entrypoint
ENTRYPOINT ["/bin/bash", \
            "-c", "/home/gitpod/miniconda3/envs/pyquil/bin/jupyter lab \
            --notebook-dir=/home/gitpod/workspace --ip='0.0.0.0' --port=8887 --no-browser \
            --allow-root --NotebookApp.token='quantum-dev-forest'"]