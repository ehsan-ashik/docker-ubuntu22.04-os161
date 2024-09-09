#! /bin/bash
#set -xe

SCRIPT_DIR=/root/os161Setup
OS161_DIR=/root/os161
TOOLBUILD_DIR=$OS161_DIR/toolbuild
TOOLS_DIR=$OS161_DIR/tools
MAKE_FLAGS="-j -s"
MAKE_INSTALL_FLAGS="-j -s"

## add to path
PATH=$OS161_DIR/tools/bin:$PATH
echo "export PATH=$PATH" > $HOME/.bashrc

# create setup dira
mkdir -p $OS161_DIR $TOOLBUILD_DIR $TOOLS_DIR $TOOLS_DIR/bin

## building binutils
tar -xvf `find binutils-*` -C $TOOLBUILD_DIR
cd $TOOLBUILD_DIR/binutils*
find . -name '*.info' | xargs touch
touch intl/plural.c
cd $SCRIPT_DIR
cd $TOOLBUILD_DIR/binutils-2.24+os161-2.1
./configure --nfp --disable-werror --target=mips-harvard-os161 --prefix=$TOOLS_DIR
make $MAKE_FLAGS
make install $MAKE_INSTALL_FLAGS
cd $SCRIPT_DIR

## building gcc 
rm -rf $TOOLBUILD_DIR/gcc-* $TOOLBUILD_DIR/buildgcc
tar -xvf `find gcc-*` -C $TOOLBUILD_DIR
cd $TOOLBUILD_DIR/gcc-*
find . -name '*.info' | xargs touch
touch intl/plural.c
./contrib/download_prerequisites
cp $SCRIPT_DIR/replacements/reload1.c ./gcc/reload1.c
cd ..
mkdir buildgcc
cd buildgcc
../gcc-*/configure \
	--enable-languages=c,lto \
	--nfp --disable-shared --disable-threads \
	--disable-libmudflap --disable-libssp \
	--disable-libstdcxx --disable-nls \
	--target=mips-harvard-os161 \
	--prefix=$TOOLS_DIR
cd ..
cd buildgcc
gmake #$MAKE_FLAGS
gmake  install #$MAKE_FLAGS
cd $SCRIPT_DIR

## building gdb
rm -rf $TOOLBUILD_DIR/gdb-*
tar -xvf `find gdb-*` -C $TOOLBUILD_DIR
cd $TOOLBUILD_DIR/gdb-*
find . -name '*.info' | xargs touch
touch intl/plural.c
./configure --target=mips-harvard-os161 --prefix=$TOOLS_DIR
cp $SCRIPT_DIR/replacements/sim-arange.h ./sim/common/sim-arange.h
make $MAKE_FLAGS
make install $MAKE_INSTALL_FLAGS
cd $SCRIPT_DIR

## building sys161
rm -rf $TOOLBUILD_DIR/sys161-*
tar -xvf sys161-* -C $TOOLBUILD_DIR
cd $TOOLBUILD_DIR/sys161-*
cp $SCRIPT_DIR/replacements/onsel.h ./include/onsel.h
./configure --prefix=$TOOLS_DIR mipseb
make $MAKE_FLAGS
make install $MAKE_INSTALL_FLAGS
cd $SCRIPT_DIR

## building os161
rm -rf $TOOLBUILD_DIR/os161-*
tar -xvf os161-* -C $OS161_DIR
mv $OS161_DIR/os161-* $OS161_DIR/src 
cp $SCRIPT_DIR/replacements/usemtest.c $OS161_DIR/src/userland/testbin/usemtest/usemtest.c

exit