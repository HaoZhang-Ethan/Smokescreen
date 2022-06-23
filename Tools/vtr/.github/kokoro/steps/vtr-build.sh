#!/bin/bash

if [ -z ${VTR_CMAKE_PARAMS+x} ]; then
	echo "Missing $$VTR_CMAKE_PARAMS value"
	exit 1
fi

if [ -z $LOGICAL_CORES ]; then
	echo "Missing $$LOGICAL_CORES value"
	exit 1
fi

export FAILURE=0
make -k CMAKE_PARAMS="$VTR_CMAKE_PARAMS" -j$LOGICAL_CORES || export FAILURE=1

echo
echo
echo
echo

# When the build fails, produce the failure output in a clear way
if [ $FAILURE -ne 0 ]; then
        make CMAKE_PARAMS="$VTR_CMAKE_PARAMS" -j1
        exit 1
fi
