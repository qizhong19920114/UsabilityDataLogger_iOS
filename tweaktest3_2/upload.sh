#!/bin/sh

make
make package 
export THEOS_DEVICE_IP=172.29.2.93

make package install

