#!/bin/bash

source ./env

echo $NETWORK_ID

docker build --rm -f "Dockerfile" -t $CONTAINER_NAME:$VERSION .
