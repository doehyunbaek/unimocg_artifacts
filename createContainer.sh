#!/bin/sh
docker image rm -f unimocgimage
docker build -f docker/Dockerfile docker -t unimocgimage
