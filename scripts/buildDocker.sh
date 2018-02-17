#!/bin/sh

pushd $(dirname $0) >/dev/null
cd ..

docker tag targoman/e4mt_server:latest targoman/e4mt_server:$(date +"%y%m%d_%H%M%S")
docker rmi targoman/e4mt_server:latest
docker build -t targoman/e4mt_server:latest -f scripts/Dockerfile .

popd > /dev/null
