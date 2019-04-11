#!/bin/bash
chmod 0666 /dev/tpm*
ln -s /dev/tpm0 /dev/tcm
