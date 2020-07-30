#!/bin/bash
x=$#
n=$(( ( RANDOM % x )  + 1 ))
echo ${!n}
