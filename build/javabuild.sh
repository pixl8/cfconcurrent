#!/bin/bash

cd `dirname $0`
cd ./java-src

mvn package
cp target/cfconcurrent-3.0.0-jar-with-dependencies.jar ../../luceelib/cfconcurrent.jar

cd ../java-src-jakarta
mvn package
cp target/cfconcurrent-3.0.0-jakarta-jar-with-dependencies.jar ../../luceelib/cfconcurrent-jakarta.jar