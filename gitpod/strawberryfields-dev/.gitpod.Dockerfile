FROM gitpod/workspace-base:latest

LABEL name="strawberryfields-dev"
LABEL description="Development Environment for Xanadu Strawberry Fields"
LABEL maintainer="Alberto Acuto alberto.acuto@nttdata.com"
LABEL vendor="NTT DATA"

# Set version levels
ENV CONDA_VERSION 22.11.1
ENV JUPYTER_VERSION 1.0.0
ENV JUPYTERLAB_VERSION 3.5.3
ENV PYTHON_VERSION 3.9.16
ENV IPYKERNEL_VERSION 5.3.4

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

# Create environment for Xanadu Strawberry Fields
RUN conda create --name strawberryfields --yes python=$PYTHON_VERSION ipykernel=$IPYKERNEL_VERSION && \
    conda run --name strawberryfields pip install -r requirements.txt && \
    conda run --name strawberryfields python -m ipykernel install --user --name strawberryfields --display-name "Strawberry Fields"

# Clean Conda installation
RUN conda clean --yes --all

# Create Jupyter Notebook folder
RUN mkdir /home/gitpod/workspace && cd /home/gitpod/workspace

# Set working directory
WORKDIR /home/gitpod/workspace

# Set prompt
RUN echo "export PS1='🐳 \[\033[1;34m\]\W \[\033[1;36m\]$ \[\033[0m\]'" >> ~/.bashrc

# Expose port for Jupyter Lab web access
EXPOSE 8884

# Define entrypoint
ENTRYPOINT ["/bin/bash", \
            "-c", "//home/gitpod/miniconda3/envs/strawberryfields/bin/jupyter lab \
            --notebook-dir=/home/gitpod/workspace --ip='0.0.0.0' --port=8884 --no-browser \
            --allow-root --NotebookApp.token='quantum-dev-strawberryfields'"]