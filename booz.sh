#!/bin/bash

all=$*
tokens=$all

if [[ $all =~ '-'([0-9]+) ]]
then
	n="${BASH_REMATCH[1]}"
	all=${all//-$n/}
	tokens=$(seq 1 $n)
fi

for i in $tokens
do
	picked=$(pick $all)
	echo $picked
	all=${all//$picked/}
done
