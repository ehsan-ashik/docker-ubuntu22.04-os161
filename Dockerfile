# base image
FROM ubuntu:22.04

# labels
LABEL author "Ehsan Ul Haque <ashik.buet10@gmail.com>"

# initialize the shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# install necessary packages before starting the toolchain setup
RUN apt-get --yes update && \
      apt-get install build-essential --yes && \
      apt-get install gdb --yes && \
      apt-get install wget --yes && \
      apt-get install libncurses-dev --yes && \
      apt-get install bmake --yes

# variables for directories and base url of the setup files
ARG SETUP_DIR=/root/os161Setup
ARG WORK_DIR=/root/cs4300
ARG BASE_URL=http://os161.org/download/    

# os161 toolchain 
ARG BINUTILS=binutils-2.24+os161-2.1.tar.gz
ARG GCC=gcc-4.8.3+os161-2.1.tar.gz
ARG GDB=gdb-7.8+os161-2.1.tar.gz
ARG OS161=os161-base-2.0.3.tar.gz
ARG SYS161=sys161-2.0.8.tar.gz

# download the toolchains
RUN mkdir -p "${WORK_DIR}"
RUN mkdir -p "${SETUP_DIR}" && cd ${SETUP_DIR} && \
    wget -nc "${BASE_URL}${BINUTILS}" && \
    wget -nc "${BASE_URL}${GCC}" && \
    wget -nc "${BASE_URL}${GDB}" && \
    wget -nc "${BASE_URL}${OS161}" && \
    wget -nc "${BASE_URL}${SYS161}" 

# copy the setup scripts and replacement files
COPY "setup-toolchains.sh" "setup-workdir.sh" "build-kernel.sh" ${SETUP_DIR}/
ADD "replacements" ${SETUP_DIR}/replacements

# initiate the toolchains setup from the setup-toolchains.sh script
RUN cd ${SETUP_DIR} && chmod +x ./setup-toolchains.sh && ./setup-toolchains.sh

# setting up environment variable for os161
ARG OS161_DIR=/root/os161
ENV PATH="${OS161_DIR}/tools/bin:${PATH}"

# set up working environment from the setup-workdir.sh script
RUN cd ${SETUP_DIR} && chmod +x ./setup-workdir.sh && ./setup-workdir.sh

# clean up setup directory after the setup is complete
RUN rm -r ${SETUP_DIR}

# set working directory
WORKDIR ${WORK_DIR}

# command for the shell
CMD ["/bin/bash"]