#!/bin/bash
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
