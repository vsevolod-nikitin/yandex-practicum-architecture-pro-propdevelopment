#!/bin/bash

printf "= Create namespace =\n"
kubectl apply -f 01-create-namespace.yaml

printf "= Gatekeeper =\n"
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/v3.22.2/deploy/gatekeeper.yaml
sleep 30

printf "= ConstraintTemplates =\n"
kubectl apply -f gatekeeper/constraint-templates/
sleep 30

printf "= Constraints =\n"
kubectl apply -f gatekeeper/constraints/
sleep 30

printf "= [POD] insecure =\n"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: non-read-only-pod
  namespace: audit-zone
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 1000
    runAsNonRoot: true
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: nginx
    image: nginx:latest
    command: ["sleep", "3600"]
    securityContext:
      allowPrivilegeEscalation: false
      capabilities:
        drop: ["ALL"]
EOF

printf "= [POD] secure =\n"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: read-only-pod
  namespace: audit-zone
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 1000
    runAsNonRoot: true
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: nginx
    image: nginx:latest
    command: ["sleep", "3600"]
    securityContext:
      readOnlyRootFilesystem: true
      allowPrivilegeEscalation: false
      capabilities:
        drop: ["ALL"]
    volumeMounts:
    - name: config
      mountPath: /config
  volumes:
  - name: config
    emptyDir: {}
EOF