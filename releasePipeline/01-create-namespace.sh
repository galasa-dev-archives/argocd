#!/bin/bash

set -e

kubectl create namespace galasa-branch-release

kubectl get secret gpgkey --namespace=galasa-tekton -o json | jq 'del(.metadata.namespace,.metadata.resourceVersion,.metadata.uid, .metadata.creationTimestamp, .metadata.selfLink)' | kubectl apply --namespace=galasa-branch-release -f -
kubectl get secret gpggradle --namespace=galasa-tekton -o json | jq 'del(.metadata.namespace,.metadata.resourceVersion,.metadata.uid, .metadata.creationTimestamp, .metadata.selfLink)' | kubectl apply --namespace=galasa-branch-release -f -
kubectl get secret mavengpg --namespace=galasa-tekton -o json | jq 'del(.metadata.namespace,.metadata.resourceVersion,.metadata.uid, .metadata.creationTimestamp, .metadata.selfLink)' | kubectl apply --namespace=galasa-branch-release -f -
kubectl get secret harbor-user-pass --namespace=galasa-tekton -o json | jq 'del(.metadata.namespace,.metadata.resourceVersion,.metadata.uid, .metadata.creationTimestamp, .metadata.selfLink)' | kubectl apply --namespace=galasa-branch-release -f -
kubectl get secret galasadev-cert --namespace=galasa-tekton -o json | jq 'del(.metadata.namespace,.metadata.resourceVersion,.metadata.uid, .metadata.creationTimestamp, .metadata.selfLink)' | kubectl apply --namespace=galasa-branch-release -f -
kubectl get secret github-creds --namespace=galasa-tekton -o json | jq 'del(.metadata.namespace,.metadata.resourceVersion,.metadata.uid, .metadata.creationTimestamp, .metadata.selfLink)' | kubectl apply --namespace=galasa-branch-release -f -
kubectl get secret maven-creds --namespace=galasa-tekton -o json | jq 'del(.metadata.namespace,.metadata.resourceVersion,.metadata.uid, .metadata.creationTimestamp, .metadata.selfLink)' | kubectl apply --namespace=galasa-branch-release -f -
kubectl get secret harbor-creds --namespace=galasa-tekton -o json | jq 'del(.metadata.namespace,.metadata.resourceVersion,.metadata.uid, .metadata.creationTimestamp, .metadata.selfLink)' | kubectl apply --namespace=galasa-branch-release -f -

echo "Complete"
