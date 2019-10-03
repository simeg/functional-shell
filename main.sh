#!/usr/bin/env bash

set -e

source "./map.sh";

ls
echo ---------------
echo test1,test2,test3 | map split , | map append a

