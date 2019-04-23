#!/bin/bash
function download {
	git clone https://github.com/biparadox/cube-1.3.git
	git clone https://github.com/biparadox/gm_sm2_master
	git clone https://github.com/TCLab-BJUT/cube-tcm.git
}

function patchcode {
	KERNEL_VERSION=`uname -r`
	patch -p1 < ./patcher/patch_gm_sm2.patch
	if [[ KERNEL_VERSION == "4.[01].*" ]] || [[ KERNEL_VERSION == "[0123].*" ]]
	then
		echo "No need to patch vtcm-dev"
	else
		patch -p1 < ./patcher/patch_vtcmd_dev.patch
	fi
}

function setuuid {
	uuid=`sudo dmidecode | grep UUID | awk {'print $2'}`
	echo $uuid > ./cube-1.3/proc/plugin/uuid
}

function setenv {
	cp $HOME/.bashrc $HOME/.bashrc.withoutcube
	if grep 'cube-1.3' $HOME/.bashrc > /dev/null 2>&1
	then
		echo "already set cube env"
	else
		echo "# CUBE ENV" >> $HOME/.bashrc
		echo "oldpwd=\`pwd\`" >> $HOME/.bashrc
		echo "cd '`pwd`/cube-1.3'" >> $HOME/.bashrc
		echo "source ./set_env.sh" >> $HOME/.bashrc
		echo "cd '`pwd`/cube-tcm'" >> $HOME/.bashrc
		echo "source ./set_env.sh" >> $HOME/.bashrc
		echo "cd \$oldpwd" >> $HOME/.bashrc
		echo "success"
	fi
}

function build {
	download

	VTCM_INSTALL_PATH=`pwd`
	export CUBE_PATH=$VTCM_INSTALL_PATH/cube-1.3
	export CUBELIBPATH=$CUBE_PATH/cubelib
	export CUBESYSPATH=$CUBE_PATH/proc
	export LD_LIBRARY_PATH=$CUBELIBPATH/lib/:$LD_LIBRARY_PATH
	export CUBE_BASE_DEFINE=$CUBE_PATH/proc/main/base_define
	export CUBE_DEFINE_PATH=$CUBE_PATH/proc/define
	export CUBE_SYS_PLUGIN=$CUBE_PATH/proc/plugin/

	patchcode

	setuuid

	cd cube-1.3/cubelib
	make
	cd ../proc/main
	make
	cd ../src
	make
	cd ../../../
	cd gm_sm2_master
	make
	cd ../cube-tcm
	cp ../gm_sm2_master/bin/*.so locallib/bin

	export CUBEAPPPATH=`pwd` 
	export CUBE_APP_PLUGIN=$CUBEAPPPATH/plugin/:$CUBE_APP_PLUGIN
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
	cd ../../..

	setenv
}

function rmenv {
	if grep 'cube-1.3' $HOME/.bashrc > /dev/null 2>&1
	then
		if [ -e $HOME/.bashrc.withoutcube ]
		then
			echo "restore with backup file"
			rm -rf $HOME/.bashrc
			mv $HOME/.bashrc.withoutcube $HOME/.bashrc
		else
			echo "No backup file found, restore from /etc/skel/"
			cp /etc/skel/.bashrc $HOME/
		fi
	else
		echo "nothing to restore"
	fi
}

function quit {
	sudo rmmod vtcmd_dev
	sudo killall main_proc
}

function vtcmd_dev {
	cd ./cube-tcm/module/vtcmd_dev
	sudo ./load_tpmd_dev.sh 13200
	sudo chmod 0666 /dev/tcm
	sudo chmod 0666 /dev/vtcm*
	cd -
}

function unvtcmd_dev {
	sudo rmmod vtcmd_dev
}

function run {
	sudo killall main_proc

	sudo rmmod vtcmd_dev

	VTCM_INSTALL_PATH=`pwd`
	export CUBE_PATH=$VTCM_INSTALL_PATH/cube-1.3
	export CUBELIBPATH=$CUBE_PATH/cubelib
	export CUBESYSPATH=$CUBE_PATH/proc
	export LD_LIBRARY_PATH=$CUBELIBPATH/lib/:$LD_LIBRARY_PATH
	export CUBE_BASE_DEFINE=$CUBE_PATH/proc/main/base_define
	export CUBE_DEFINE_PATH=$CUBE_PATH/proc/define
	export CUBE_SYS_PLUGIN=$CUBE_PATH/proc/plugin/
	cd cube-tcm
	export CUBEAPPPATH=`pwd` 
	export CUBE_APP_PLUGIN=$CUBEAPPPATH/plugin/:$CUBE_APP_PLUGIN
	export LD_LIBRARY_PATH=$CUBEAPPPATH/locallib/bin:$LD_LIBRARY_PATH
	export CUBE_DEFINE_PATH=$CUBEAPPPATH/define:$CUBE_DEFINE_PATH

	cd vtcm_new_emulator
	./main_proc &

	cd ../..

	vtcmd_dev
}

function initvm {
	sudo chmod 0666 /dev/tpm*
	sudo ln -s /dev/tpm0 /dev/tcm
}

function usage {
	echo "Usage $0 [command]"
	echo "Command:"
	echo "	build - download, patch and build vtcm, set UUID, set env"
	echo "	download - just download all packages"
	echo "	setuuid - set UUID"
	echo "	patchcode - patch source code"
	echo "	setenv - set env in .bashrc"
	echo "	rmenv - remove env from .bashrc"
	echo "	run - run vtcm emulator and load vtcmd_dev"
	echo "	quit - quit vtcm emulator and unload vtcmd_dev"
	echo "	vtcmd_dev - load vtcmd_dev"
	echo "	unvtcmd_dev - unload vtcmd_dev"
	echo "	initvm - init virtual machine TPM"
}

if [[ $USER == "root" ]]
then
	echo "Do not run this script in ROOT user"
	exit -1
fi
if [ -n "$1" ]
then
	case "$1" in
		build) build ;;
		download) download ;;
		setuuid) setuuid ;;
		patchcode) patchcode ;;
		setenv) setenv ;;
		rmenv) rmenv ;;
		run) run ;;
		quit) quit ;;
		vtcmd_dev) vtcmd_dev ;;
		unvtcmd_dev) unvtcmd_dev ;;
		initvm) initvm ;;
		*) echo "Wrong Command!"
		   usage ;;
	esac
else
	usage
fi
