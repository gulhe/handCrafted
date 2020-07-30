#!/usr/bin/env bash

previous=''
while true;do
	if [[ "${previous}" != "$($@)" ]]; then
		clear
		previous=$($@)
		($@)
	fi
	sleep 1
done
