#! /bin/bash
nano comp.s

as comp.s -o comp.o
#echo compiled!
ld comp.o -o comp
#echo linked!
time ./comp
#./comp
