#!/bin/bash
# Run this to create the folder structure with a dir for each month in a dir for the year

mkdir "$1"

for x in $(seq -w 01 12); do mkdir "$1"/"$x" ; done
