#!/bin/bash

if [[ $TRAVIS_TAG == v* ]] || [[ $TRAVIS_BRANCH == release* ]] ; then
	if [[ $TRAVIS_TAG == v* ]] ; then
		BUILD_NUMBER=`printf %07d $TRAVIS_BUILD_NUMBER`
		VERSION_NUMBER="${TRAVIS_TAG//v}+${BUILD_NUMBER}"
		ZIP_FILE="cfconcurrent-${TRAVIS_TAG//v}-${BUILD_NUMBER}.zip"
		RELEASE_NAME="stable"
	elif [[ $TRAVIS_BRANCH == release* ]] ; then
		VERSION_NUMBER="${TRAVIS_BRANCH//release-}-SNAPSHOT${TRAVIS_BUILD_NUMBER}"
		ZIP_FILE="cfconcurrent-${TRAVIS_BRANCH//release-}-SNAPSHOT${TRAVIS_BUILD_NUMBER}.zip"
		RELEASE_NAME="bleeding-edge"
	fi

	BUILD_DIR=build/

	echo "Building CFConcurrent"
	echo "====================="
	echo "Version number  : $VERSION_NUMBER"
	echo

	rm -rf $BUILD_DIR
	mkdir -p $BUILD_DIR

	echo "Copying files to $BUILD_DIR..."
	rsync -a ./ --exclude=".*" --exclude="$BUILD_DIR" --exclude="*.sh" --exclude="build" --exclude="*.log" "$BUILD_DIR" || exit 1
	echo "Done."

	cd $BUILD_DIR
	echo "Inserting version number..."
	sed -i "s/VERSION_NUMBER/$VERSION_NUMBER/" box.json
	sed -i "s/DOWNLOAD_LOCATION/$ZIP_FILE/" box.json
	echo "Done."

	echo "Zipping up..."
	zip -rq $ZIP_FILE * -x jmimemagic.log || exit 1
	mv $ZIP_FILE ../
	cd ../
	find ./*.zip -exec aws s3 cp {} s3://pixl8-public-packages/cfconcurrent/ --acl public-read \;

    cd $BUILD_DIR;
    CWD="`pwd`";

    box forgebox login username="$FORGEBOXUSER" password="$FORGEBOXPASS";
    box publish directory="$CWD";
else
	echo "Not publishing. This is not a tagged release.";
fi

echo done

echo "Build complete :)"