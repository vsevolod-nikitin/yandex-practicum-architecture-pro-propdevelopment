#!/bin/bash

printf "= Create namespace =\n"
kubectl apply -f 01-create-namespace.yaml

printf "= [POD] privileged: true =\n"
kubectl apply -f insecure-manifests/01-privileged-pod.yaml 2>&1 | grep "Error"

printf "= [POD] hostPath =\n"
kubectl apply -f insecure-manifests/02-hostpath-pod.yaml 2>&1 | grep "Error"

printf "= [POD] root user =\n"
kubectl apply -f insecure-manifests/03-root-user-pod.yaml 2>&1 | grep "Error"

printf "= [POD] secure =\n"
kubectl apply -f secure-manifests/01-secure.yaml
kubectl apply -f secure-manifests/02-secure.yaml
kubectl apply -f secure-manifests/03-secure.yaml

printf "= [POD] status =\n"
kubectl get pods -n audit-zone