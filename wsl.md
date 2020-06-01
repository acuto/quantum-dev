# Using the WSL Terminal to access Docker on Windows

### While Docker Desktop for Windows is primarily intended to be accessed through the PowerShell native terminal, it is often more profitable to exploit a Unix-based shell such as Bash, for its wider backing among communities and support on various platforms. This guide covers how to access Docker from a WSL terminal running Ubuntu.

## Using Docker integration with WSL 2

If you're running Windows 10 2004 or newer, it is highly recommended to take advantage of the Docker Desktop integration with Windows Subsystem for Linux 2. WSL 2 introduces a significant architectural change as it is a full Linux kernel built by Microsoft, allowing Linux containers to run natively without emulation. With Docker Desktop running on WSL 2, users can leverage Linux workspaces and avoid having to maintain both Linux and Windows build scripts. In addition, WSL 2 provides improvements to file system sharing, boot time, and allows access to some cool new features for Docker Desktop users.

Detailed instructions on how to install WSL 2 and integrate with Docker Desktop can be found on [Microsoft](https://docs.microsoft.com/en-us/windows/wsl/) and [Docker](https://docs.docker.com/docker-for-windows/wsl/) documentation.

---
> **Note**: Docker Desktop relies on a Linux Virtual Machine on Windows and Mac hosts. The size of the VM tends to grow in size with time &mdash; due a faulty estimation of free disk blocks in the Docker/Linux system. If getting low in disk free space (and in general to restart with a clean Docker environment) periodically issue a "``Clean/Purge data``" on the ``Troubleshoot`` panel in the Docker Desktop application. Consider that all containers and images will be lost as a result of that operation &mdash; but remember that containers are meant to be volatile by design! If you cannot rely on a local Docker Registry, in order to avoid massive data download when rebuilding images, consider saving your built images (see below "_Saving and loading Docker images_").
---

## Installing the Docker client on WSL 1

For Windows versions prior to Windows 10 2004, Hyper-V must be enabled in order to run Docker. The feature can be enabled from an elevated PowerShell prompt, prior to Docker installation:

```powershell
PS> Set-ExecutionPolicy RemoteSigned
PS> Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V –All
```

Consider that once Hyper-V is enabled on a host, any other common hypervisors &mdash; like VMware or VirtualBox &mdash; cannot be run anymore. In order to run them again, you need to disable the Hyper-V feature:

```powershell
PS> Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V –All
```

 For instructions about how to install WSL, please refer to [Microsoft documentation](https://docs.microsoft.com/en-us/windows/wsl/).

The Docker Engine does not run on WSL 1, so you NEED to have Docker for Windows installed on your host machine anyway. What we'll end up with at the end of this guide is the Docker client running on Linux (WSL) sending commands to your Docker Engine daemon installed on Windows.

We'll assume that Ubuntu 18.04 is installed as WSL on Windows 10, and install Docker CE through the following commands:

```sh
# Update the apt package list
sudo apt-get update -y

# Install Docker's package dependencies
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Download and add Docker's official public PGP key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Verify the fingerprint.
sudo apt-key fingerprint 0EBFCD88

# Add the `stable` channel's Docker upstream repository
#
# If you want to live on the edge, you can change "stable" below to "test" or
# "nightly". I highly recommend sticking with stable!
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Update the apt package list (for the new apt repo)
sudo apt-get update -y

# Install the latest version of Docker CE
sudo apt-get install -y docker-ce

# Allow your user to access the Docker CLI without needing root access
sudo usermod -aG docker $USER

# Install Python and Pip
sudo apt-get install -y python3 python3-pip

# Install Docker Compose into your user's home directory
pip3 install --user docker-compose
```

When that finishes, you'll end up having everything installed in Linux (restarting the terminal session might be required). Yet, as mentioned before, the Docker Engine does not run in WSL so if you write any command like docker images, you'll see a message like this one:

    Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?

You need to tell the Docker client where the Docker host is, and you can do that by using the ``-H`` option as follows:

```sh
$ docker -H localhost:2375 images
```

If you don't want to type the host every time, you can set up and environment variable called ``DOCKER_HOST`` to ``localhost:2375``, and execute this instruction automatically at shell creation through the following command:

```sh
# Allow Docker Client on WSL to access Docker Host running on Windows
echo "export DOCKER_HOST=tcp://localhost:2375" >> ~/.bashrc && source ~/.bashrc
```

---
> **Note**: Make sure you expose the Docker daemon port to ``localhost`` so that the Docker Client running on WSL can access it, otherwise this won't work! This is done by checking the "``Expose daemon on tcp://localhost:2375 without TLS``" option in the Docker Desktop settings panel.
---

## Fixing the WSL mounts

The last thing we need to do is set things up so that volume mounts work. When using WSL, Docker for Windows expects you to supply your volume paths in a format that matches this: ``/c/Users/<USER>/Documents/Jupyter``. Yet, WSL doesn’t work like that. Instead, it uses the ``/mnt/c/Users/<USER>/Documents/Jupyter`` format.

Assuming you're running Windows 10 18.03+, open a WSL terminal to create and modify the new WSL configuration file (again, starting a new WSL session is required to apply changes):

```sh
$ sudo nano /etc/wsl.conf

[automount]
enabled=true
# Mount root to /drive/ instead of /mnt/drive for docker compatibility.
root=/
# Unsets (unmasks) -wx bits for group/other so perms don't show up as 777 on WSL.
options="metadata,umask=22,fmask=11"
```

We need to set ``root=/`` because this will make your drives mounted at ``/c`` or ``/e`` instead of ``/mnt/c`` or ``/mnt/e``.

The ``options = "metadata"`` line is not necessary but it will fix folder and file permissions on WSL mounts so that everything isn’t 777 all the time within the WSL mounts &mdash; so it's highly recommended.