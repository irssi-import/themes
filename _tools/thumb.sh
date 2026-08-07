#!/bin/bash
set -eu

shopt -s extglob

for f in *.@(png|gif|jpg); do
    if [[ $f -nt thumb/t_"$f" ]]; then
	echo "$f"
	magick "$f" -resize 240x240\> thumb/t_"$f"
    fi
done
