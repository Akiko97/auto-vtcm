#!/bin/bash
git clone https://github.com/biparadox/cube-1.3.git
git clone https://github.com/TCLab-BJUT/gm_sm2.git
git clone https://github.com/TCLab-BJUT/cube-tcm.git

VTCM_INSTALL_PATH=`pwd`
export CUBE_PATH=$VTCM_INSTALL_PATH/cube-1.3
export CUBELIBPATH=$CUBE_PATH/cubelib
export CUBESYSPATH=$CUBE_PATH/proc
export LD_LIBRARY_PATH=$CUBELIBPATH/lib/:$CUBESYSPATH/plugin:$LD_LIBRARY_PATH
export CUBE_BASE_DEFINE=$CUBE_PATH/proc/main/base_define
export CUBE_DEFINE_PATH=$CUBE_PATH/proc/define
export CUBE_SYS_PLUGIN=$CUBE_PATH/proc/plugin/
export CUBE_APP_PLUGIN=../plugin
cd cube-1.3/cubelib
make
cd ../proc/main
make
cd ../src
make
cd ../../../
cd gm_sm2
make
cd ../cube-tcm
cp ../gm_sm2/bin/*.so locallib/bin

export CUBEAPPPATH=`pwd` 
export CUBE_APP_PLUGIN=$CUBEAPPPATH/plugin/
export LD_LIBRARY_PATH=$CUBEAPPPATH/locallib/bin:$LD_LIBRARY_PATH
export CUBE_DEFINE_PATH=$CUBEAPPPATH/define:$CUBE_DEFINE_PATH
cd vtcm_new_emulator
ln -s $CUBESYSPATH/main/main_proc
cd ..
cd vtcm_utils
ln -s $CUBESYSPATH/main/main_proc
cd ..
cd vtcm_v0_utils
ln -s $CUBESYSPATH/main/main_proc
cd ..
cd vtcm_v1_utils
ln -s $CUBESYSPATH/main/main_proc
cd ..

cd locallib
make
cd ..

cd module
make
cd tcmd_dev
make
cd ../vtcmd_dev
make 
cd ../../

cd init_module/vtcm_init
make
cd -
