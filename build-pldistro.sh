#!/bin/sh

make stage1=true PLDISTRO=planetlab
make iptables
./rebuild-bootcd.sh
make
