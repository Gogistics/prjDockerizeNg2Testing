#!/bin/bash
# Program:
# get dir of javac/java
# History:
# 04/02/2017
set -e
dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"