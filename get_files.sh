#!/bin/sh
parallel --jobs 8 --colsep " " curl -sL -o {2} {1} :::: files.txt