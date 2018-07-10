#!/bin/bash

cd `dirname $0`

box install || exit 1;

exitcode=0

box stop name="cfconcurrenttests"

declare -a engines=("lucee@4.5.5" "adobe@10" "adobe@11", "adobe@2016" )

## now loop through the above array
for engine in "${engines[@]}"
do
	echo "Running tests on engine: $engine";

	box start directory="./" serverConfigFile="./server-cfconcurrenttests.json" cfengine="$engine" save=false;
	box testbox run verbose=false || exitcode=1
	box stop name="cfconcurrenttests"
done

exit $exitcode
