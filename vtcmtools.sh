#!/bin/bash
function download {
	git clone https://github.com/biparadox/cube-1.3.git
	git clone https://github.com/biparadox/gm_sm2_master.git
	git clone https://github.com/TCLab-BJUT/cube-tcm.git
}

function download-dev {
	git clone https://github.com/biparadox/cube_manage.git
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

function rmenv {
	if grep 'VTCMENV' $HOME/.bashrc > /dev/null 2>&1
	then
		sed -e '/VTCMENV/d' $HOME/.bashrc > $HOME/.bashrc.tmp
		mv $HOME/.bashrc.tmp $HOME/.bashrc
		echo "vtcm env has been removed"
	elif grep 'CUBEDEVENV' $HOME/.bashrc > /dev/null 2>&1
	then
		sed -e '/CUBEDEVENV/d' $HOME/.bashrc > $HOME/.bashrc.tmp
		mv $HOME/.bashrc.tmp $HOME/.bashrc
		echo "cube development env has been removed"
	else
		echo "nothing to remove from .bashrc"
	fi
}

function setenv {
	rmenv
	echo "# VTCMENV" >> $HOME/.bashrc
	echo "oldpwd=\`pwd\` # VTCMENV" >> $HOME/.bashrc
	echo "cd '`pwd`/cube-1.3' # VTCMENV" >> $HOME/.bashrc
	echo "source ./set_env.sh # VTCMENV" >> $HOME/.bashrc
	echo "cd '`pwd`/cube-tcm' # VTCMENV" >> $HOME/.bashrc
	echo "source ./set_env.sh # VTCMENV" >> $HOME/.bashrc
	echo "cd \$oldpwd # VTCMENV" >> $HOME/.bashrc
	echo "add vtcm env to .bashrc"
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

function setenv-dev {
	rmenv
	echo "# CUBEDEVENV" >> $HOME/.bashrc
	echo "oldpwd=\`pwd\` # CUBEDEVENV" >> $HOME/.bashrc
	echo "cd '`pwd`/cube-1.3' # CUBEDEVENV" >> $HOME/.bashrc
	echo "source ./set_env.sh # CUBEDEVENV" >> $HOME/.bashrc
	echo "cd '`pwd`/cube-tcm' # CUBEDEVENV" >> $HOME/.bashrc
	echo "source ./set_env.sh # CUBEDEVENV" >> $HOME/.bashrc
	echo "cd '`pwd`/cube_manage' # CUBEDEVENV" >> $HOME/.bashrc
	echo "source ./set_env.sh # CUBEDEVENV" >> $HOME/.bashrc
	echo "cd '`pwd`/cube_module' # CUBEDEVENV" >> $HOME/.bashrc
	echo "source ./set_env.sh # CUBEDEVENV" >> $HOME/.bashrc
	echo "cd \$oldpwd # CUBEDEVENV" >> $HOME/.bashrc
	echo "add cube development env to .bashrc"
}

function _setworkshop {
	cp -a ./cube_manage/module_workshop ./cube_module
	cd ./cube_module/tools/header_make
	ln -s $CUBE_PATH/proc/main/main_proc
	cd ../module_create
	ln -s $CUBE_PATH/proc/main/main_proc
	cd $VTCM_INSTALL_PATH
}

function setworkshop {
	if [ -d cube_module ]
	then
		read -p "cube_module already exists, reset? [Y/n]" ch
		if [[ $ch == "Y" ]]
		then
			rm -rf cube_module
			_setworkshop
		else
			_setworkshop
		fi
	fi
}

function dev {
	if [ -d cube-1.3 ]
	then
		echo "already build"
	else
		build
	fi
	download-dev
	setenv-dev
	VTCM_INSTALL_PATH=`pwd`
	export CUBE_PATH=$VTCM_INSTALL_PATH/cube-1.3
	export CUBELIBPATH=$CUBE_PATH/cubelib
	export CUBESYSPATH=$CUBE_PATH/proc
	export LD_LIBRARY_PATH=$CUBELIBPATH/lib/:$LD_LIBRARY_PATH
	export CUBE_BASE_DEFINE=$CUBE_PATH/proc/main/base_define
	export CUBE_DEFINE_PATH=$CUBE_PATH/proc/define
	export CUBE_SYS_PLUGIN=$CUBE_PATH/proc/plugin/
	cd cube_manage
	export CUBEAPPPATH=`pwd` 
	export CUBE_APP_PLUGIN=$CUBEAPPPATH/plugin/:$CUBE_APP_PLUGIN
	export LD_LIBRARY_PATH=$CUBEAPPPATH/locallib/bin:$LD_LIBRARY_PATH
	export CUBE_DEFINE_PATH=$CUBEAPPPATH/define:$CUBE_DEFINE_PATH

	echo "CUBESYSPATH is ${CUBESYSPATH}"
	cd locallib
	make
	cd ../module
	make
	cd $VTCM_INSTALL_PATH

	setworkshop
}

function restorebashrc {
	cp /etc/skel/.bashrc $HOME/
}

function quit {
	sudo rmmod vtcmd_dev
	sudo killall main_proc
}

function vtcmd_dev {
	cd ./cube-tcm/module/vtcmd_dev
	sudo ./load_vtcmd_dev.sh 13200
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
	echo "Commands:"
	echo "	build - download, patch and build vtcm, set UUID, set env"
	echo "	dev - build development enviroment"
	echo "	clean - clean all downloaded or modified file"
	echo ""
	echo "	run - run vtcm emulator and load vtcmd_dev"
	echo "	quit - quit vtcm emulator and unload vtcmd_dev"
	echo ""
	echo "	download - just download all packages"
	echo "	download-dev - download cube_manage"
	echo "	setuuid - set UUID"
	echo "	patchcode - patch source code"
	echo "	setenv - set vtcm env to .bashrc"
	echo "	setenv-dev - set cube development env to .bashrc"
	echo "	rmenv - remove env from .bashrc"
	echo "	vtcmd_dev - load vtcmd_dev"
	echo "	unvtcmd_dev - unload vtcmd_dev"
	echo "	setworkshop - (re)copy module_workshop to new folder cube_module"
	echo "	initvm - init virtual machine TPM"
	echo "	restorebashrc - restore .bashrc file with system"
}

function clean {
	read -p "your cube_module folder will be removed [Y/n]: " ch
	if [[ $ch == "Y" ]]
	then
		quit
		rmenv
		rm -rf cube-1.3 gm_sm2_master cube-tcm cube_manage cube_module
		echo "you can safely remove auto-vtcm folder"
	else
		echo "Abort"
	fi
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
		download-dev) download-dev ;;
		setuuid) setuuid ;;
		patchcode) patchcode ;;
		setenv) setenv ;;
		setenv-dev) setenv-dev ;;
		rmenv) rmenv ;;
		run) run ;;
		quit) quit ;;
		vtcmd_dev) vtcmd_dev ;;
		unvtcmd_dev) unvtcmd_dev ;;
		initvm) initvm ;;
		restorebashrc) restorebashrc ;;
		dev) dev ;;
		clean) clean ;;
		setworkshop) setworkshop ;;
		*) echo "Wrong Command!"
		   usage ;;
	esac
else
	usage
fi
