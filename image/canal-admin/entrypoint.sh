#!/bin/bash
set -e
envsubst < ./application-tmp.yml > ./conf/application.yml
./bin/startup.sh