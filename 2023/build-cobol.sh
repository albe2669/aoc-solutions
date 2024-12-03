#!/bin/bash

file=$1

cobc -g -O2 -std=default -I /usr/include -free -x -static $file.cbl -o $file