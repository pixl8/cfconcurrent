#!/bin/bash

cd `dirname $0`
CWD="`pwd`"

box install || exit 1;

exitcode=0

box stop name="cfconcurrenttests"

declare -a engines=("lucee@5" "lucee@4.5.5" "adobe@11" "adobe@2016" "adobe@2018" )

## now loop through the above array
for engine in "${engines[@]}"
do
	echo "Running tests on engine: $engine";

	box start directory="$CWD" serverConfigFile="$CWD/server-cfconcurrenttests.json" cfengine="$engine" saveSettings=false;
	box testbox run verbose=false || exitcode=1
	box stop name="cfconcurrenttests"

	echo "sleeping for 5s to allow commandbox to properly shutdown server :)"
	sleep 5s
done

exit $exitcode
