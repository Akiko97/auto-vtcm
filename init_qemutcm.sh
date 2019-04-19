#!/bin/bash
sudo chmod 0666 /dev/tpm*
sudo ln -s /dev/tpm0 /dev/tcm
