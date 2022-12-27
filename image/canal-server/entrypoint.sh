#!/bin/bash
set -e
envsubst < ./canal_local_tmp.properties > ./conf/canal_local.properties
./bin/startup.sh local