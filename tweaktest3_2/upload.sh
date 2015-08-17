#!/bin/sh

make
make package 
export THEOS_DEVICE_IP=192.168.1.72

make package install

