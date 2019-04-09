#!/bin/bash
killall main_proc

rmmod vtcmd_dev

VTCM_INSTALL_PATH=`pwd`
export CUBE_PATH=$VTCM_INSTALL_PATH/cube-1.3
export CUBELIBPATH=$CUBE_PATH/cubelib
export CUBESYSPATH=$CUBE_PATH/proc
export LD_LIBRARY_PATH=$CUBELIBPATH/lib/:$CUBESYSPATH/plugin:$LD_LIBRARY_PATH
export CUBE_BASE_DEFINE=$CUBE_PATH/proc/main/base_define
export CUBE_DEFINE_PATH=$CUBE_PATH/proc/define
export CUBE_SYS_PLUGIN=$CUBE_PATH/proc/plugin/
cd cube-tcm
export CUBEAPPPATH=`pwd` 
export CUBE_APP_PLUGIN=$CUBEAPPPATH/plugin/
export LD_LIBRARY_PATH=$CUBEAPPPATH/locallib/bin:$LD_LIBRARY_PATH
export CUBE_DEFINE_PATH=$CUBEAPPPATH/define:$CUBE_DEFINE_PATH

cd vtcm_new_emulator
./main_proc &

cd ../module/vtcmd_dev
./load_tpmd_dev.sh 13200
chmod 0666 /dev/tcm

cd ../../..
