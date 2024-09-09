#! /bin/bash
#set -xe

## variables for directory names
SCRIPT_DIR=/root/os161Setup
OS161_DIR=/root/os161
TOOLBUILD_DIR=$OS161_DIR/toolbuild
TOOLS_DIR=$OS161_DIR/tools
WORKING_DIR=/root/cs4300
ROOT_DIR=$WORKING_DIR/root
SRC_DIR=$WORKING_DIR/src

## flags
MAKE_FLAGS="-j"
MAKE_INSTALL_FLAGS="-j"
BMAKE_FLAGS="-j 4"

## create working directory and copy files
mkdir -p $WORKING_DIR $ROOT_DIR $SRC_DIR
tar -xvf $SCRIPT_DIR/os161-* -C $WORKING_DIR
mv $WORKING_DIR/os161-*/* $WORKING_DIR/src 
rm -r $WORKING_DIR/os161-*

## copy the build kernel file and necessary replacements
cp $SCRIPT_DIR/build-kernel.sh $WORKING_DIR/build-kernel.sh
cp $SCRIPT_DIR/replacements/usemtest.c $SRC_DIR/userland/testbin/usemtest/usemtest.c

## make user files
cd $SRC_DIR
./configure --ostree=$ROOT_DIR
bmake $BMAKE_FLAGS
bmake $BMAKE_FLAGS install

## configure the kernel
cd $SRC_DIR/kern/conf
./config DUMBVM

## make kernel files
cd ../compile/DUMBVM
bmake $BMAKE_FLAGS depend
bmake $BMAKE_FLAGS
bmake $BMAKE_FLAGS install 

## copy configuration file
cp $TOOLS_DIR/share/examples/sys161/sys161.conf.sample $ROOT_DIR/sys161.conf

## create disks in the root directory
cd $ROOT_DIR
disk161 create LHD0.img 5M
disk161 create LHD1.img 5M

exit