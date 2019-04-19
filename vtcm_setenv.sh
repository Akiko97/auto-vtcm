#!/bin/bash
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
