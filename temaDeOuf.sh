#!/usr/bin/env bash

while true;do
	clear
	previous=$($@)
	($@)
	sleep 1
done
