#!/bin/sh

make
make package 
export THEOS_DEVICE_IP=192.168.1.252

make package install

