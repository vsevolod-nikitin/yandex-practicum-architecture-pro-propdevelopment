#!/bin/bash

kubectl run test-$RANDOM --rm -i -t --image=alpine -n propdevelopment -- sh / # wget -qO- --timeout=2 http://back-end-api-app