#!/bin/bash


set -uxo

./bin/clone.sh

cd oscar
apt-get update
apt-get install -y maven

mvn clean verify
mvn package

#mvn -Dmaven.test.skip=true clean verify
#mvn package -Dmaven.test.skip=true


