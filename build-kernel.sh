#! /bin/bash
#set -xe

## set the kernel name to be built and run
KERNEL=DUMBVM

## variables for directories
TESTBUILD_DIR=/root/cs4300
TEST_OSTREE=$TESTBUILD_DIR/root
TEST_SRC_DIR=$TESTBUILD_DIR/src

## flag variables
MAKE_FLAGS="-j"
MAKE_INSTALL_FLAGS="-j"
BMAKE_FLAGS="-j 4"

## configure and build user files
cd $TEST_SRC_DIR
./configure --ostree=$TEST_OSTREE
bmake $BMAKE_FLAGS
bmake $BMAKE_FLAGS install

## configure and build kernel files
cd $TEST_SRC_DIR/kern/conf
./config $KERNEL

cd ../compile/$KERNEL
bmake $BMAKE_FLAGS depend
bmake $BMAKE_FLAGS
bmake $BMAKE_FLAGS install 

## run the kernel
cd $TEST_OSTREE
sys161 kernel-$KERNEL