#!/bin/sh

pushd $(dirname $0) >/dev/null
cd ..

docker tag targoman/textprocessor_server:latest targoman/textprocessor_server:$(date +"%y%m%d_%H%M%S")
docker rmi targoman/textprocessor_server:latest
docker build -t targoman/textprocessor_server:latest -f scripts/Dockerfile .

popd > /dev/null
