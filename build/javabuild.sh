#!/bin/bash

cd `dirname $0`
cd ./java-src

mvn package
cp artifacts/cfconcurrent-2.1.1.jar ../../luceelib/