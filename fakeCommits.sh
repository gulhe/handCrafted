#!/usr/bin/env bash

all=$*

for item in $(seq ${all}); do
	touch f-${item};
	git add f-${item}
	git commit -m C-${item}
done

