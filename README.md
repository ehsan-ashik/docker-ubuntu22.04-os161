# Docker Image for OS161-2.0.3 in Ubuntu 22.04
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
