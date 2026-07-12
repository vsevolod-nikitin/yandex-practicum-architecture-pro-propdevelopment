#!/bin/bash

AUDIT_LOG="${1:-audit.log}"

jq 'select(.objectRef.resource=="secrets" and .verb=="get")' "$AUDIT_LOG" >> audit-extract.json
jq 'select(.verb=="get" and .objectRef.subresource=="exec")' "$AUDIT_LOG" >> audit-extract.json
jq 'select(.objectRef.resource=="pods" and (.requestObject.spec.containers[]?.securityContext.privileged? == true // empty))' "$AUDIT_LOG" >> audit-extract.json
jq 'select(.objectRef.resource=="rolebindings" and .verb=="create") | select(.requestObject.roleRef.name == "cluster-admin")' "$AUDIT_LOG" >> audit-extract.json
grep -i 'audit-policy' "$AUDIT_LOG" | jq . >> audit-extract.json