#!/bin/bash

cd `dirname $0`
cd ../../

if  [[ $TRAVIS_PULL_REQUEST == 'true' ]] ; then
	echo "Finished (not publishing due to running in a pull request)."
	exit 0;
fi

if [[ $TRAVIS_TAG == v* ]] ; then
	box forgebox login username="$FORGEBOXUSER" password="$FORGEBOXPASS" || exit 1;
	box publish || exit 1
else
	echo "Skipping publishing, not on stable or release branch in a travis build."
fi
