#!/bin/bash

docker build -t wiiu-samples-builder .
docker run --name wiiu-build-container wiiu-samples-builder
docker cp wiiu-build-container:/work/dist ./samples
docker rm wiiu-build-container
