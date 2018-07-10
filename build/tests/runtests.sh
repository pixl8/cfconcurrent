#!/bin/bash

cd `dirname $0`
CWD="`pwd`"

box install || exit 1;

exitcode=0

box stop name="cfconcurrenttests"

declare -a engines=("lucee@4.5.5" "adobe@10" "adobe@11" "adobe@2016" )

## now loop through the above array
for engine in "${engines[@]}"
do
	echo "Running tests on engine: $engine, using directory: $CWD and server config: $CWD/server-cfconcurrenttests.json";

	box start directory="$CWD" serverConfigFile="$CWD/server-cfconcurrenttests.json" cfengine="$engine" save=false;
	box testbox run verbose=false || exitcode=1
	box stop name="cfconcurrenttests"
done

exit $exitcode
