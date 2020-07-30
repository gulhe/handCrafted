#!/usr/bin/env bash

echo $@ | qrencode -o - -t UTF8 | lolcat
