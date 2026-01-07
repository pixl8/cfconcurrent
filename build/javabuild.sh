#!/bin/bash

cd `dirname $0`
cd ./java-src

mvn package
cp target/cfconcurrent-2.1.1-jar-with-dependencies.jar ../../luceelib/cfconcurrent-2.1.1.jar