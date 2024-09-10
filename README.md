# Docker Image for OS161 v.2.0.3 in Ubuntu 22.04
This repository contains the docker image that installs OS161 v.2.0.3, based on Ubuntu 22.04. OS161 is an educational operating system developed for teaching OS concepts in undergraduate and graduate level OS courses such as CS4300.  

The image includes the following -
* OS161 toolchains (gcc, gdb, binutils, etc.)
* OS161-2.0.3 source codes setup in the working directory (`root/cs4300`)
* System/161-2.0.8 - machine simulator for OS161

## Usage 
1. Install **Docker** (https://www.docker.com/).
2. Clone the repository into the prefered dorectory.
3. From the cloned directory, build the `.Dockerfile` with the command: `docker build -t docker-ubuntu22.04-os161 .`
4. Once the build is complete start the container with the command: `docker run -i -t docker-ubuntu22.04-os161 /bin/bash`

## Getting the Image from DockerHub
If you do not want to build the image by cloning the repo, you can pull the image directly from DockerHub with the command: `docker pull ehaque052/docker-ubuntu22.04-os161`

Once the image is succesfully pulled, you can run the image with the command: `docker run -i -t ehaque052/docker-ubuntu22.04-os161 /bin/bash`

## Setting Up a Local Working Directory
To work on the assignments, creating a local working directory can be helpful, especially to make changes in the kernel and to open the OS161 codebase to a code editor or IDE. To create a local working directory **Docker Volume** can be used with the steps mentioned below - 
1. Pull the image from DockerHub or build the image from this repository as mentioned above.
2. Create a working directory in your local machine and `cd` into the working directory.
3. Create a temp container from the image and run the following command to copy the src files from the container into the local directory: `docker cp <COINTAINER_ID>:/root/cs4300 $(pwd)/cs4300` (Note that, in windows machine `$(pwd)` will not work and `%cd%` should be used. The temp container can be removed after this step).
4. Once the src files are copied into the working directory, go the the `cs4300` directory on your local machine and execute the command: `docker run -it --volume $(pwd):/root/cs4300 ehaque052/docker-ubuntu22.04-os161 /bin/bash` (This will mount the local `cs4300` directory to the container's working directory).

## Building and Running OS161
As part of the Docker build process, the script `build-kernel.sh` is copied to the os161 working directory (`root/cs4300`) in the container. To build and run the `DUMBVM` kernel, execute the following command from the woring directory: `chmod +x ./build-kernel.sh && ./build-kernel.sh`

For subsequent runs of the compiled kernel execute the follwing commands:
* `cd root/cs4300/root`
* `sys161 kernel-DUMBVM`

## Acknowledgement
The toolchain setup scripts are obtained from this [Github repo](https://github.com/dev-otl/os161-toolchain-setup-on-wsl-and-linux-ubuntu-22).

## References
1. Learn more about OS161 - http://www.os161.org/
2. Toolchain setup instructions - http://www.os161.org/resources/setup.html
2. More on the assignments and toolchain setup - https://ops-class.org/asst/overview
